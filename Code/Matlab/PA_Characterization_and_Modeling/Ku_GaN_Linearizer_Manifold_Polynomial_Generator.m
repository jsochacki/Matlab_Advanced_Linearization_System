clear all

Plot_True=0;

MAXIMUM_POWER=60; %maximum possible power of 60 Watts before you will
                  %get an overflow (based on output power detector)
MAXIMUM_VOLTAGE=4.096; %maximum possible voltage of 4.096 Volts before you will
                  %get an overflow
MAXIMUM_VOLTAGE_PD=3;

data_array=Ku_GaN_Linearizer_Manifold('Two_Tone','10MHz','13.75GHz');

Range_Start=1; Range_End=length(data_array{1});

Vd1=data_array{1}(Range_Start:Range_End).';
Vd2=data_array{2}(Range_Start:Range_End).';
Vattext=data_array{3}(Range_Start:Range_End).';
%Pout_total=data_array{5}(:).';
%Pout_total=0.001*power(10,data_array{(length(data_array)-3)}(Range_Start:Range_End).'./10);
Pout_total=MAXIMUM_VOLTAGE_PD.*(0.001*power(10,data_array{(length(data_array)-3)}(Range_Start:Range_End).'./10)./MAXIMUM_POWER);
SRG1x_IMD3_low_f=data_array{(length(data_array)-2)}(Range_Start:Range_End).';
SRG1x_IMD3_high_f=data_array{(length(data_array)-1)}(Range_Start:Range_End).';
Pin_total=data_array{(length(data_array))}(Range_Start:Range_End).';

Vd1_Pout_total=[]; Vd2_Pout_total=[]; Vattext_Pout_total=[]; Pout_Array={};
Poly_Array={}; Vd1_poly=[]; Vd2_poly=[]; Vattext_poly=[];
for Range_Piece=Range_Start:1:(Range_End-1)
clear Vd1_poly Vd2_poly Vattext_poly
[Vd1_poly Vd1_Pout_total]=Least_Squares_Linear_Approximation(Vd1(Range_Piece:(Range_Piece+1)),Pout_total(Range_Piece:(Range_Piece+1)));
[Vd2_poly Vd2_Pout_total]=Least_Squares_Linear_Approximation(Vd2(Range_Piece:(Range_Piece+1)),Pout_total(Range_Piece:(Range_Piece+1)));
[Vattext_poly Vattext_Pout_total]=Least_Squares_Linear_Approximation(Vattext(Range_Piece:(Range_Piece+1)),Pout_total(Range_Piece:(Range_Piece+1)));
Poly_Array{Range_Piece}={Vd1_poly,Vd2_poly,Vattext_poly};
Pout_Array{Range_Piece}={Vd1_Pout_total,Vd2_Pout_total,Vattext_Pout_total};
end

Range_Piece=1; 
for Range_Piece=Range_Start:1:(Range_End-1)
Vd1_poly_approx=Pout_Array{Range_Piece}{1}*Poly_Array{Range_Piece}{1};
Vd2_poly_approx=Pout_Array{Range_Piece}{2}*Poly_Array{Range_Piece}{2};
Vattext_poly_approx=Pout_Array{Range_Piece}{3}*Poly_Array{Range_Piece}{3};
end

Pout_test=[];
if Plot_True
    Range_Piece=1; Vd1_poly_approx=[]; Vd2_poly_approx=[]; Vattext_poly_approx=[];
    for Range_Piece=Range_Start:1:(Range_End-1)
	Prange_temp=[linspace(Pout_Array{Range_Piece}{1}(1),Pout_Array{Range_Piece}{1}(2),10).' ones(10,1)];
    Vd1_poly_approx=[Vd1_poly_approx;Prange_temp*Poly_Array{Range_Piece}{1}];
    Vd2_poly_approx=[Vd2_poly_approx;Prange_temp*Poly_Array{Range_Piece}{2}];
    Vattext_poly_approx=[Vattext_poly_approx;Prange_temp*Poly_Array{Range_Piece}{3}];
    Pout_test=[Pout_test;linspace(Pout_Array{Range_Piece}{1}(1),Pout_Array{Range_Piece}{1}(2),10).'];
    end
    %figure(Range_Piece)
    figure(1)
    hold off, grid off
    plot(Pout_total,Vd1,'bo',Pout_total,Vd2,'ro',Pout_total,Vattext,'ko')
    hold on
    plot(Pout_test,Vd1_poly_approx,'b.',Pout_test,Vd2_poly_approx,'r.',Pout_test,Vattext_poly_approx,'k.')
    grid on
end

%Above I have done all the least squares piecewise interpolation and
%generated the floating point coefficients.
%Now I need to move into the fixed point domain for the control
%system I wrote

%Defined Above
%MAXIMUM_POWER=60; %maximum possible power of 60 Watts before you will
                  %get an overflow (based on output power detector)
%Defined Above
%MAXIMUM_VOLTAGE=4.096; %maximum possible voltage of 4.096 Volts before you will
                  %get an overflow

N_BITS_RESOLUTION_ADC=12; %Resolution of the DAC's in the design
N_BITS_RESOLUTION_PD_ADC=12; %Resolution of the PD DAC's in the design
N_BITS_RESOLUTION_MAC=24; %Minimum Necessary Resolution of the coefficients in the design

SF1=power(2,N_BITS_RESOLUTION_ADC)/MAXIMUM_VOLTAGE;
SF2=SF1*(MAXIMUM_VOLTAGE_PD/power(2,N_BITS_RESOLUTION_PD_ADC));
%Multiplication bit gain takes into account multiplication gain 
%(N_BITS_RESOLUTION_ADC+N_BITS_RESOLUTION_MAC-1)-N_BITS_RESOLUTION_ADC
%and
%coefficient resolution gain 
%N_BITS_RESOLUTION_MAC-1-N_BITS_RESOLUTION_PD_ADC
Multiplication_Bit_Gain=N_BITS_RESOLUTION_MAC-1-N_BITS_RESOLUTION_PD_ADC;

%Re-pack the poly array
i=0;
Poly_Mem_Vec_Vd1=[]; Poly_Mem_Vec_Vd2=[]; Poly_Mem_Vec_Vdattext=[];
for i=1:1:max(size(Poly_Array))
    Poly_Mem_Vec_Vd1=[Poly_Mem_Vec_Vd1;Poly_Array{i}{1}(1)*SF2;Poly_Array{i}{1}(2)*SF1];
    Poly_Mem_Vec_Vd2=[Poly_Mem_Vec_Vd2;Poly_Array{i}{2}(1)*SF2;Poly_Array{i}{2}(2)*SF1];
    Poly_Mem_Vec_Vdattext=[Poly_Mem_Vec_Vdattext;Poly_Array{i}{3}(1)*SF2;Poly_Array{i}{3}(2)*SF1];
end

Vd1_fxp=round((Vd1./MAXIMUM_VOLTAGE).*power(2,N_BITS_RESOLUTION_ADC));
Vd2_fxp=round((Vd2./MAXIMUM_VOLTAGE).*power(2,N_BITS_RESOLUTION_ADC));
Vattext_fxp=round((Vattext./MAXIMUM_VOLTAGE).*power(2,N_BITS_RESOLUTION_ADC));
Pout_total_fxp=round((Pout_total./MAXIMUM_VOLTAGE_PD).*power(2,N_BITS_RESOLUTION_PD_ADC));
Poly_Mem_Vec_Vd1_fxp=round((Poly_Mem_Vec_Vd1).*power(2,N_BITS_RESOLUTION_MAC-1-N_BITS_RESOLUTION_PD_ADC)); %-1 is for the sign bit
Poly_Mem_Vec_Vd2_fxp=round((Poly_Mem_Vec_Vd2).*power(2,N_BITS_RESOLUTION_MAC-1-N_BITS_RESOLUTION_PD_ADC)); %-1 is for the sign bit
Poly_Mem_Vec_Vdattext_fxp=round((Poly_Mem_Vec_Vdattext).*power(2,N_BITS_RESOLUTION_MAC-1-N_BITS_RESOLUTION_PD_ADC)); %-1 is for the sign bit

%%Now I test to make sure the fixed point is done correctly
%%and so I know what to scale the output by in the FPGA
i=0; j=1; Vd1_fxp_output=[];
for i=1:2:length(Poly_Mem_Vec_Vd1_fxp)
Vd1_fxp_output=[Vd1_fxp_output;[Pout_total_fxp(j) 1]*Poly_Mem_Vec_Vd1_fxp(i:i+1)];
j=j+1;
end
Vd1_fxp_output=[Vd1_fxp_output;[Pout_total_fxp(j) 1]*Poly_Mem_Vec_Vd1_fxp(i:i+1)];

i=0; j=1; Vd2_fxp_output=[];
for i=1:2:length(Poly_Mem_Vec_Vd2_fxp)
Vd2_fxp_output=[Vd2_fxp_output;[Pout_total_fxp(j) 1]*Poly_Mem_Vec_Vd2_fxp(i:i+1)];
j=j+1;
end
Vd2_fxp_output=[Vd2_fxp_output;[Pout_total_fxp(j) 1]*Poly_Mem_Vec_Vd2_fxp(i:i+1)];

i=0; j=1; Vdattext_fxp_output=[];
for i=1:2:length(Poly_Mem_Vec_Vdattext_fxp)
Vdattext_fxp_output=[Vdattext_fxp_output;[Pout_total_fxp(j) 1]*Poly_Mem_Vec_Vdattext_fxp(i:i+1)];
j=j+1;
end
Vdattext_fxp_output=[Vdattext_fxp_output;[Pout_total_fxp(j) 1]*Poly_Mem_Vec_Vdattext_fxp(i:i+1)];

Vd1_fxp_output=round(Vd1_fxp_output./power(2,Multiplication_Bit_Gain));
Vd2_fxp_output=round(Vd2_fxp_output./power(2,Multiplication_Bit_Gain));
Vdattext_fxp_output=round(Vdattext_fxp_output./power(2,Multiplication_Bit_Gain));

Vd1_fxp_output
Vd2_fxp_output
Vdattext_fxp_output
