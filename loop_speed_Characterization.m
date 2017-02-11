for n=1:1:100, tic;, s(n)=Read_ADC128SXXX(mobj,0,3)*(3.271/2^12);, t(n)=toc;, end;
figure(1), plot(s), figure(2), plot(t)