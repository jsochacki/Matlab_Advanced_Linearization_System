DSP_Builder_Setup(dsp_builder_path)
mobj=Find_and_Open_Master;

%SETUP START
DEBUG=1; RUN_ALL_AT_ONCE=1;
Vd1_Channel=1; Vd2_Channel=2; Vattext_Channel=3; Vattinp_Channel=4; Vinput_PD_Channel=5;
Number_Of_Read_Variables=5;
%SETUP END

state=[]; state_number=1; done=0;
while ~done
    input('Press enter when ready to save state characteristics.');
    
    for i=1:1:Number_Of_Read_Variables
        if DEBUG
            Write_and_Update_DAC128SXXX(mobj,'00000020',i,dec2hex(i*state_number,8))
        end
        state{state_number}(i)=Read_ADC128SXXX(mobj,'00000000',i)
    end
    
    done=input('Press 0 then enter to add another state or 1 then enter to quit.');
    state_number=state_number+1;
end

for n=1:1:length(state{1})
    for i=1:1:length(state)
        state_variable(i,n)=state{i}(n);
    end
end

%Assign the collumns to the variables in the manner you have measured them
Vd1=state_variable(:,Vd1_Channel);
Vd2=state_variable(:,Vd2_Channel);
Vattext=state_variable(:,Vattext_Channel);
Vattinp=state_variable(:,Vattinp_Channel);
Vinput_PD=state_variable(:,Vinput_PD_Channel);

Vd1_Pin_total=[]; Vd2_Pin_total=[]; Vattext_Pin_total=[]; Vattinp_Pin_total=[]; Pin_Array={};
Poly_Array={}; Vd1_poly=[]; Vd2_poly=[]; Vattext_poly=[]; Vattinp_poly=[];
for Range_Piece=1:1:(size(state_variable,1)-1)
clear Vd1_poly Vd2_poly Vattext_poly Vattinp_poly
[Vd1_poly Vd1_Pin_total]=Least_Squares_Linear_Approximation(Vd1(Range_Piece:(Range_Piece+1)),Vinput_PD(Range_Piece:(Range_Piece+1)));
[Vd2_poly Vd2_Pin_total]=Least_Squares_Linear_Approximation(Vd2(Range_Piece:(Range_Piece+1)),Vinput_PD(Range_Piece:(Range_Piece+1)));
[Vattext_poly Vattext_Pin_total]=Least_Squares_Linear_Approximation(Vattext(Range_Piece:(Range_Piece+1)),Vinput_PD(Range_Piece:(Range_Piece+1)));
[Vattinp_poly Vattinp_Pin_total]=Least_Squares_Linear_Approximation(Vattinp(Range_Piece:(Range_Piece+1)),Vinput_PD(Range_Piece:(Range_Piece+1)));
Poly_Array{Range_Piece}={Vd1_poly,Vd2_poly,Vattext_poly,Vattinp_poly};
Pin_Array{Range_Piece}={Vd1_Pin_total,Vd2_Pin_total,Vattext_Pin_total,Vattinp_Pin_total};
end

Range_Piece=1; 
for Range_Piece=1:1:(size(state_variable,1)-1)
Vd1_poly_approx=Pin_Array{Range_Piece}{1}*Poly_Array{Range_Piece}{1};
Vd2_poly_approx=Pin_Array{Range_Piece}{2}*Poly_Array{Range_Piece}{2};
Vattext_poly_approx=Pin_Array{Range_Piece}{3}*Poly_Array{Range_Piece}{3};
Vattinp_poly_approx=Pin_Array{Range_Piece}{4}*Poly_Array{Range_Piece}{4};
end

Pin_test=[];
if Plot_True
    Range_Piece=1; Vd1_poly_approx=[]; Vd2_poly_approx=[]; Vattext_poly_approx=[]; Vattinp_poly_approx=[];
    for Range_Piece=1:1:(size(state_variable,1)-1)
	Prange_temp=[linspace(Pin_Array{Range_Piece}{1}(1),Pin_Array{Range_Piece}{1}(2),10).' ones(10,1)];
    Vd1_poly_approx=[Vd1_poly_approx;Prange_temp*Poly_Array{Range_Piece}{1}];
    Vd2_poly_approx=[Vd2_poly_approx;Prange_temp*Poly_Array{Range_Piece}{2}];
    Vattext_poly_approx=[Vattext_poly_approx;Prange_temp*Poly_Array{Range_Piece}{3}];
    Vattinp_poly_approx=[Vattinp_poly_approx;Prange_temp*Poly_Array{Range_Piece}{4}];
    Pin_test=[Pin_test;linspace(Pin_Array{Range_Piece}{1}(1),Pin_Array{Range_Piece}{1}(2),10).'];
    end
    %figure(Range_Piece)
    figure(1)
    hold off, grid off
    plot(Vinput_PD,Vd1,'bo',Vinput_PD,Vd2,'ro',Vinput_PD,Vattext,'ko',Vinput_PD,Vattinp,'go')
    hold on
    plot(Pin_test,Vd1_poly_approx,'b.',Pin_test,Vd2_poly_approx,'r.',Pin_test,Vattext_poly_approx,'k.',Pin_test,Vattinp_poly_approx,'g.')
    grid on
end

save('./polyvars_14GHz_spoof3.mat','Vd1_Channel','Vd2_Channel','Vattext_Channel',...
    'Vattinp_Channel','Vinput_PD_Channel',...
    'Vinput_PD','Poly_Array')

if ~RUN_ALL_AT_ONCE
DSP_Builder_Setup(dsp_builder_path)
mobj=Find_and_Open_Master;
load('./polyvars_14GHz_spoof3.mat')
%Reconstruct the values in state
Range_Piece=1;
Vd1_poly_approx=[];
Vd2_poly_approx=[];
Vattext_poly_approx=[];
Vattinp_poly_approx=[];
for Range_Piece=1:1:11
Vd1_poly_approx(1,Range_Piece)=[Vinput_PD(Range_Piece) 1]*Poly_Array{Range_Piece}{1}
Vd2_poly_approx(1,Range_Piece)=[Vinput_PD(Range_Piece) 1]*Poly_Array{Range_Piece}{2}
Vattext_poly_approx(1,Range_Piece)=[Vinput_PD(Range_Piece) 1]*Poly_Array{Range_Piece}{3}
Vattinp_poly_approx(1,Range_Piece)=[Vinput_PD(Range_Piece) 1]*Poly_Array{Range_Piece}{4}
end
Vd1_poly_approx(2:end+1)=Vd1_poly_approx(1:end);
Vd1_poly_approx(1)=Vd1_poly_approx(2);
Vattext_poly_approx(2:end+1)=Vattext_poly_approx(1:end);
Vattext_poly_approx(1)=Vattext_poly_approx(2);
Vattinp_poly_approx(2:end+1)=Vattinp_poly_approx(1:end);
Vattinp_poly_approx(1)=Vattinp_poly_approx(2);
Vd1_poly_approx=Vd1_poly_approx+15;
Vattext_poly_approx=Vattext_poly_approx+70+22;
Vattinp_poly_approx(2)=Vattinp_poly_approx(2)+20;
Vattinp_poly_approx(3)=Vattinp_poly_approx(3)-0;
Vattinp_poly_approx(8)=Vattinp_poly_approx(8)+3;
Vattinp_poly_approx(9)=Vattinp_poly_approx(9)+0;
Vattinp_poly_approx(10)=Vattinp_poly_approx(10)+0;
Vattinp_poly_approx(11)=Vattinp_poly_approx(11)+0;
Vattinp_poly_approx(12)=Vattinp_poly_approx(12)-40;
Vattinp_poly_approx(7:12)=Vattinp_poly_approx(7:12)+0;
Vattinp_poly_approx(4:12)=Vattinp_poly_approx(4:12)-0;
Vattinp_poly_approx=Vattinp_poly_approx-40;
((3.3)/(2^12))*(Vd1_poly_approx)
((3.3)/(2^12))*(Vattext_poly_approx)
((3.3)/(2^12))*(Vattinp_poly_approx)
Vd1=Vd1_poly_approx;
Vd2=ones(12,1);
Vattext=Vattext_poly_approx;
Vattinp=Vattinp_poly_approx;
state_variable=ones(12,1);
%end
end

Vinput_PD_Current=[]; Vinput_PD_Poly_in=[]; Vinput_PD_Poly_in_old=0;
AAPD_ON=1;
while AAPD_ON
    Vinput_PD_Current=Read_ADC128SXXX(mobj,'00000000',Vinput_PD_Channel);
    if Vinput_PD_Current <= min(Vinput_PD) | (sum(Vinput_PD_Current > Vinput_PD)==1)
        Vinput_PD_Poly_in=min(Vinput_PD);
        Range_Piece=1;
    elseif Vinput_PD_Current > max(Vinput_PD)
        Vinput_PD_Poly_in=max(Vinput_PD);    
        Range_Piece=size(Poly_Array,2);
    else
        Vinput_PD_Poly_in=Vinput_PD_Current;
        Range_Piece=sum(Vinput_PD_Current > Vinput_PD);
    end
    %Range_Piece
    %Vinput_PD_Current
    
    Vinput_PD_Poly_in=(Vinput_PD_Poly_in_old+Vinput_PD_Poly_in)/2;
    Vinput_PD_Poly_in_old=Vinput_PD_Poly_in;
    
    Write_and_Update_DAC128SXXX(mobj,'00000020',Vd1_Channel,dec2hex(uint32(floor([Vinput_PD_Poly_in 1]*Poly_Array{Range_Piece}{Vd1_Channel})),8));
    Write_and_Update_DAC128SXXX(mobj,'00000020',Vd2_Channel,dec2hex(uint32(floor([Vinput_PD_Poly_in 1]*Poly_Array{Range_Piece}{Vd2_Channel})),8));
    Write_and_Update_DAC128SXXX(mobj,'00000020',Vattext_Channel,dec2hex(uint32(floor([Vinput_PD_Poly_in 1]*Poly_Array{Range_Piece}{Vattext_Channel})),8));
    Write_and_Update_DAC128SXXX(mobj,'00000020',Vattinp_Channel,dec2hex(uint32(floor([Vinput_PD_Poly_in 1]*Poly_Array{Range_Piece}{Vattinp_Channel})),8));
end

Vinput_PD_Poly_in=Vinput_PD(12)
((3.3)/(2^12))*double(uint32(floor([Vinput_PD_Poly_in 1]*Poly_Array{Range_Piece}{Vd1_Channel})))
((3.3)/(2^12))*double(uint32(floor([Vinput_PD_Poly_in 1]*Poly_Array{Range_Piece}{Vd2_Channel})))
((3.3)/(2^12))*double(uint32(floor([Vinput_PD_Poly_in 1]*Poly_Array{Range_Piece}{Vattext_Channel})))
((3.3)/(2^12))*double(uint32(floor([Vinput_PD_Poly_in 1]*Poly_Array{Range_Piece}{Vattinp_Channel})))
