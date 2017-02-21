clear all

delta_vec=[1e1+logspace(1,2,10) 1e2+logspace(1,2,10) 1e3+logspace(1,2,10) 1e4+logspace(1,2,10) 1e5+logspace(1,2,10) 1e6+logspace(1,2,10) 1e7+logspace(1,2,10) 1e8+logspace(1,2,10)];
f1=1e7; f2=f1+delta_vec;
Two_tone_PAPR=[]; Two_tone_Average_Power=[];

for i=1:1:length(delta_vec)
clear t x y Two_tone_sum
FULL_CYCLES=1e3; USAMPR=16;
t=0:(1/(2*pi*f2(i)*USAMPR)):FULL_CYCLES/(2*pi*f2(i));
x=cos(2*pi*f1.*t); y=cos(2*pi*f2(i).*t);
Two_tone_sum=x+y;

Two_tone_PAPR(i)=custom_unitless_PAPR(Two_tone_sum,[]);
Two_tone_Normalized_Average_Power(i)=sum(Two_tone_sum.*Two_tone_sum'.')/length(Two_tone_sum)/max(Two_tone_sum);
end

semilogx(f2-f1,Two_tone_PAPR) %vs tone delta
semilogx(100*(f2-f1)/f1,Two_tone_PAPR) %vs tone delta percent of carrier frequency
%for reference ku band
%1 MHz tone spacing is 0.0714% of the carrier tone and
%10 MHz tone spacing is 0.714% of the carrier tone
semilogx(f2-f1,Two_tone_PAPR,'b',f2-f1,Two_tone_Normalized_Average_Power,'k') %vs tone delta
semilogx(100*(f2-f1)/f1,Two_tone_PAPR,'b',100*(f2-f1)/f1,Two_tone_Normalized_Average_Power,'k') %vs tone delta percent of carrier frequency
plot(t,x,'r',t,y,'b',t,Two_tone_sum,'k')
