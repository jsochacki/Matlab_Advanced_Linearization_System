function [Output_Array]=Ku_GaN_Linearizer_Manifold(Test_Type,Test_Specifics,Carrier_Frequency)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       USEAGE                               %
% Test_Type - This is either Two_Tone for the two tone test  %
%             results or Spectral_Regrowth for the spectral  %
%             regrowth results.                              %
% Test_Specifics - This is either the tone spacing           %
%             when used with the two tone test option        %
%             Two_Tone (e.g. 10MHz or 1MHz) or the channel   %
%             bandwitdh, rolloff, and modulation type when   %
%             used with the spectral regrowth option         %
%             Spectral_Regrowth                              %
%             (e.g. 10.24Msymbs_25%RO_QPSK).                 %
% Carrier_Frequency - This is the frequency of the carrier   %
%             frequency that the Test of Test_Type was       %
%             performed at.                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch Test_Type

    case 'Two_Tone'

        switch Test_Specifics
            
            case '10MHz'
        
                switch Carrier_Frequency
            
                    case '13.75GHz'
                        vd1=[0.37 0.36 0.46 0.5 0.54 0.58 0.68 0.7];
                        vd2=[0 0 0 0.12 0.22 0.285 0.405 0.42];
                        vattext=[1.3 1.34 1.34 1.34 1.4 1.4 1.46 1.46];
                        pout_scl=[42 41 40 39 38 37 33 30];
                        pout_total=pout_scl+3;
                        IMD3_low_frequency=[-28.5 -36.5 -41 -40 -42 -41 -46 -42];
                        IMD3_high_frequency=[-26 -30 -37.3 -40 -41 -43.5 -47 -42];
                        pin_scl=[14.08 13.78 12.1 10.88 10.9 9.64 6.46 3.33];
                        Output_Array={vd1,vd2,vattext,pout_scl,pout_total,IMD3_low_frequency,IMD3_high_frequency,pin_scl};
                    case '14GHz'
                        vd1=[0.33 0.39 0.44 0.46 0.49 0.54 0.67 0.71];
                        vd2=[0 0 0 0.09 0.06 0.15 0.42 0.3];
                        vattext=[1.33 1.35 1.37 1.4 1.54 1.54 1.42 1.42];
                        pout_scl=[42 41 40 39 38 37 33 30];
                        pout_total=pout_scl+3;
                        IMD3_low_frequency=[-28.3 -35 -38 -40 -41 -43 -49 -42];
                        IMD3_high_frequency=[-26.5 -31.5 -37.5 -40 -42 -42 -43 -47];
                        pin_scl=[14.55 13.83 12.71 12.22 14.2 12.94 5 1.6];
                        Output_Array={vd1,vd2,vattext,pout_scl,pout_total,IMD3_low_frequency,IMD3_high_frequency,pin_scl};
                    case '14.25GHz'
                        vd1=[0 0.26 0.33 0.56 0.58 0.63 0.7 0.7];
                        vd2=[0 0 0 0.26 0.25 0.27 0.3 0.3];
                        vattext=[1.31 1.45 1.39 1.41 1.58 1.53 1.53 1.53];
                        pout_scl=[42 41 40 39 38 37 33 30];
                        pout_total=pout_scl+3;
                        IMD3_low_frequency=[-29 -39 -38 -39 -38 -38 -45 -42];
                        IMD3_high_frequency=[-26 -31.5 -38 -39 -49 -43 -47 -42];
                        pin_scl=[16.82 17.31 14.58 12.62 15 13.55 8.43 5.68];
                        Output_Array={vd1,vd2,vattext,pout_scl,pout_total,IMD3_low_frequency,IMD3_high_frequency,pin_scl};
                    case '14.5GHz'
                        vd1=[0 0 0.29 0.56 0.63 0.67 0.68 0.71];
                        vd2=[0 0 0 0.15 0.23 0.29 0.41 0.46];
                        vattext=[1.32 1.32 1.32 1.32 1.34 1.36 1.36 1.36];
                        pout_scl=[42 41 40 39 38 37 33 30];
                        pout_total=pout_scl+3;
                        IMD3_low_frequency=[-33 -40 -38 -40 -41 -46 -45 -47];
                        IMD3_high_frequency=[-27 -30 -36 -40 -45 -46 -44 -47];
                        pin_scl=[16.28 15.35 13.41 10.82 9.76 6.64 5.63 2.9];
                        Output_Array={vd1,vd2,vattext,pout_scl,pout_total,IMD3_low_frequency,IMD3_high_frequency,pin_scl};
                    otherwise
                        Output_Array={};
                end
        
            otherwise
                Output_Array={};
        end
    
    case 'Spectral_Regrowth'

        switch Test_Specifics
            
            case '10.24Msymbs_25%RO_QPSK'
        
                switch Carrier_Frequency
            
                    case '13.75GHz'
                        vd1=[0.29 0.42 0.39 0.47 0.54 0.57];
                        vd2=[0 0 0 0 0.23 0.25];
                        vattext=[1.3 1.34 1.34 1.36 1.4 1.4];
                        pout_total=[45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-33.6 -37 -39.5 -39 -39 -39];
                        SRG_1x_symbol_rate_high_frequency=[-32 -36 -40.2 -39 -39 -39];
                        pin_total=[18.15 17 15.88 14.5 14 12.72];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    case '14GHz'
                        vd1=[0.34 0.4 0.44 0.43 0.43 0.56];
                        vd2=[0 0 0 0 0.12 0.25];
                        vattext=[1.32 1.35 1.36 1.39 1.44 1.48];
                        pout_total=[45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-33 -38 -39.5 -39 -38.5 -39];
                        SRG_1x_symbol_rate_high_frequency=[-33 -38 -40 -39 -38.5 -39];
                        pin_total=[18.27 17.4 16 15.47 15.4 14.65];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    case '14.25GHz'
                        vd1=[0 0 0.21 0.24 0.31 0.4];
                        vd2=[0 0 0 0 0 0];
                        vattext=[1.32 1.36 1.36 1.38 1.43 1.47];
                        pout_total=[45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-35 -38.5 -38.8 -37 -36 -35.5];
                        SRG_1x_symbol_rate_high_frequency=[-32.5 -36 -38.8 -37 -36 -36.5];
                        pin_total=[20.23 19.59 17.77 16.97 16.7 16.13];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    case '14.5GHz'
                        vd1=[0 0.28 0.35 0.52 0.59 0.62];
                        vd2=[0 0.08 0 0.16 0.33 0.28];
                        vattext=[1.32 1.49 1.49 1.49 1.49 1.47];
                        pout_total=[45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-36 -38 -39 -40 -39 -39];
                        SRG_1x_symbol_rate_high_frequency=[-34 -35 -36.3 -37.1 -37 -37];
                        pin_total=[19.39 20.4 19.32 17.56 15.94 14.32];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    otherwise
                        Output_Array={};
                end
            
            case '36Msymbs_25%RO_QPSK'
        
                switch Carrier_Frequency
            
                    case '13.75GHz'
                        vd1=[0.29 0.42 0.39 0.47 0.54 0.57];
                        vd2=[0 0 0 0 0.23 0.25];
                        vattext=[1.3 1.34 1.34 1.36 1.4 1.4];
                        pout_total=[45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-31.5 -34 -35 -34.3 -35 -35];
                        SRG_1x_symbol_rate_high_frequency=[-30 -32 -35 -34.3 -35 -35];
                        pin_total=[18.15 17 15.88 14.5 14 12.72];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    case '14GHz'
                        vd1=[0.34 0.4 0.44 0.43 0.43 0.56];
                        vd2=[0 0 0 0 0.12 0.25];
                        vattext=[1.32 1.35 1.36 1.39 1.44 1.48];
                        pout_total=[45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-31.5 -34 -34.5 -34.8 -34.5 -34];
                        SRG_1x_symbol_rate_high_frequency=[-31 -33.8 -35 -34.8 -34.5 -34];
                        pin_total=[18.27 17.4 16 15.47 15.4 14.65];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    case '14.25GHz'
                        vd1=[0 0 0.21 0.24 0.31 0.4];
                        vd2=[0 0 0 0 0 0];
                        vattext=[1.32 1.36 1.36 1.38 1.43 1.47];
                        pout_total=[45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-33 -35 -35 -33.3 -33.5 -33];
                        SRG_1x_symbol_rate_high_frequency=[-30 -31.5 -35 -33.3 -33.5 -33];
                        pin_total=[20.23 19.59 17.77 16.97 16.7 16.13];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    case '14.5GHz'
                        vd1=[0 0.28 0.35 0.52 0.59 0.62];
                        vd2=[0 0.08 0 0.16 0.33 0.28];
                        vattext=[1.32 1.49 1.49 1.49 1.49 1.47];
                        pout_total=[45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-33 -35 -35.3 -36 -35.8 -34];
                        SRG_1x_symbol_rate_high_frequency=[-31.8 -32 -33 -33 -33 -32.5];
                        pin_total=[19.39 20.4 19.32 17.56 15.94 14.32];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    otherwise
                        Output_Array={};
                end
                        
            case '10.24Msymbs_25%RO_QPSK_MODRRC'
        
                switch Carrier_Frequency
            
                    case '14GHz'
                        vd1=[0.48 0.34 0.4 0.44 0.43 0.43 0.56];
                        vd2=[0 0 0 0 0 0.12 0.25];
                        vattext=[1.32 1.32 1.35 1.36 1.39 1.44 1.48];
                        pout_total=[46 45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-33 -38 -39.6 -42 -41 -40 -43];
                        SRG_1x_symbol_rate_high_frequency=[-32 -36.5 -38.5 -41.5 -40 -40 -43];
                        pin_total=[19.71 18.58 17.4 15.9 15.3 15.3 14.38];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    case '14.25GHz'
                        vd1=[0.69 0.66 0.52 0.63 0.24 0.31 0.4];
                        vd2=[0 0 0 0 0 0 0];
                        vattext=[1.29 1.35 1.38 1.36 1.38 1.43 1.47];
                        pout_total=[46 45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-35 -38.6 -40.5 -40 -40 -39.6 -39.8];
                        SRG_1x_symbol_rate_high_frequency=[-33.5 -37 -39 -40.5 -38.5 -39.6 -39.8];
                        pin_total=[18.92 18.76 18.27 15.8 16.8 16.52 16.05];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    case '14.5GHz'
                        vd1=[0.7 0.7 0.7 0.66 0.52 0.54 0.62];
                        vd2=[0 0 0 0 0 0 0];
                        vattext=[1.61 1.61 1.62 1.53 1.49 1.49 1.47];
                        pout_total=[46 45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-37 -39.5 -39.6 -40 -39.5 -41 -41.2];
                        SRG_1x_symbol_rate_high_frequency=[-35 -37.5 -37.5 -37.5 -37.8 -39.5 -41];
                        pin_total=[25.36 23.81 22.45 19.72 18.23 16.91 15.2];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    otherwise
                        Output_Array={};
                end
            
            case '36Msymbs_25%RO_QPSK_MODRRC'
        
                switch Carrier_Frequency
            
                    case '14GHz'
                        vd1=[0.48 0.34 0.4 0.44 0.43 0.43 0.56];
                        vd2=[0 0 0 0 0 0.12 0.25];
                        vattext=[1.32 1.32 1.35 1.36 1.39 1.44 1.48];
                        pout_total=[46 45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-34.3 -36.5 -38 -39 -39 -38 -40];
                        SRG_1x_symbol_rate_high_frequency=[-32.5 -33.8 -36.6 -38 -38 -38 -40];
                        pin_total=[19.71 18.58 17.4 15.9 15.3 15.3 14.38];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    case '14.25GHz'
                        vd1=[0.69 0.66 0.52 0.63 0.24 0.31 0.4];
                        vd2=[0 0 0 0 0 0 0];
                        vattext=[1.29 1.35 1.38 1.36 1.38 1.43 1.47];
                        pout_total=[46 45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-34 -36.5 -38.3 -37 -38 -37.8 -38];
                        SRG_1x_symbol_rate_high_frequency=[-32.5 -35 -36.8 -38.5 -36.5 -36.5 -37];
                        pin_total=[18.92 18.76 18.27 15.8 16.8 16.52 16.05];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    case '14.5GHz'
                        vd1=[0.7 0.7 0.7 0.66 0.52 0.54 0.62];
                        vd2=[0 0 0 0 0 0 0];
                        vattext=[1.61 1.61 1.62 1.53 1.49 1.49 1.47];
                        pout_total=[46 45 44 43 42 41 40];
                        SRG_1x_symbol_rate_low_frequency=[-35.5 -37.6 -40.6 -40 -39.5 -39.8 -38.5];
                        SRG_1x_symbol_rate_high_frequency=[-33.5 -34.5 -36 -35.5 -36.8 -37.5 -38];
                        pin_total=[25.36 23.81 22.45 19.72 18.23 16.91 15.2];
			        	Output_Array={vd1,vd2,vattext,pout_total,SRG_1x_symbol_rate_low_frequency,SRG_1x_symbol_rate_high_frequency,pin_total};
                    otherwise
                        Output_Array={};
                end
                
            otherwise
                Output_Array={};
        end
        
    otherwise
        Output_Array={};
    end

end