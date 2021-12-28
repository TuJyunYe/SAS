data price;
do year=2001 to 2014;
        do m =1 to 12;
month=m;
d1=0;
d2=0;
d3=0;
d4=0;
d5=0;
d6=0;
d7=0;
d8=0;
d9=0;
d10=0;
d11=0;
input y ;
sy=y**0.5;
qy=y**0.25;
lny=log(y);
if (m = 1) then d1=1;
if (m = 2) then d2=1;
if (m = 3) then d3=1;
if (m = 4) then d4=1;
if (m = 5) then d5=1;
if (m = 6) then d6=1;
if (m = 7) then d7=1;
if (m = 8) then d8=1;
if (m = 9) then d9=1;
if (m = 10) then d10=1;
if (m = 11) then d11=1;

date=mdy(month,1,year);
t+1;
output;
       end;
end;
keep date y sy qy lny t  d1-d11;
        format date monyy5.;
label y=' room ave';

cards;
303.5
305.1
311.7
321.9
318
329.2
300.3
301.8
304.2
305.1
299
282
298.9
298.6
296.8
313.1
309.9
324.3
303.8
302.9
297.5
306.6
303.4
275.3
298.5
300.3
292.4
270.2
248.4
240.7
287
284.2
298.4
291.7
287.6
276.4
309.5
299.5
302.5
302.2
312.3
318.7
311.7
308.9
296.7
303.1
303.3
285.4
296.3
313.3
306.9
307.2
319.5
319.5
317.4
311
308.9
319.8
313.7
301
323.6
317
319.7
322.9
324.5
348.9
332.3
328.9
327.3
334.9
329.7
315.1
326.3
349.7
339.9
333.7
337.6
363.9
345.8
335.2
339.1
344.1
334
318.8
329.8
343.6
346.8
348.3
337.4
365.3
346.5
339.9
334.4
335.4
327.1
310
357.3
308.9
306.9
297.4
307.3
331
327.6
313.1
324.4
325
306.6
297.7
319.2
345
317.8
308.7
314
324.3
329.5
333.9
319.6
325
326.5
318.9
334.5
355.7
337.4
333.4
338.3
346.1
354.9
351.5
349.8
347.3
346.7
340.5
399.3
352
348.9
345.7
343.6
373.5
368.2
368.4
359.8
365.7
362.7
371.9
363.1
418
400.7
365.8
369.8
393.1
378.9
383.8
367.5
381.4
380.9
382.9
391
397.6
377.4
373.4
378.5
400.9
399.6
404.2
384.6
391.9
391.2
396.9
		 .
		 .
		 .
		 .
		 .
		 .
		 .
		 .
		 .
		 .
		 .
		 .
;
symbol1 v=star i=join c=red;
symbol2 v=star i=join c=green;
symbol3 v=star i=join c=blue;
symbol4 v=star i=join c=blue;
proc gplot;
plot y *date;
title 'International Tourist Hotel - Average Room price (10NT$/night) ';

proc gplot;
plot  sy *date;
title 'Time plot of square roots of room averages ';

proc gplot;
plot  qy *date;
title 'Time plot of quartic roots of room averages ';

proc gplot;
plot  lny *date;
title 'Time plot of natural logarithms of room averages ';

proc reg;
Model  lny= t d1-d11 /p clm cli dw vif;   /*  Variance Inflation Factor */

proc autoreg;
model lny = t d1-d11/nlag=2 dwprob;  /* fit time series regression, with AR(2) error term */
output out=pred p=p lcl=l95 ucl=u95 r=res; 
/* LCLM stands for the lower limit of 95% confidence interval  */
/*LCL     stands for the lower limit of 95% prediction interval */
/* UCLM stands for the upper limit of 95% confidence interval  */
/*UCL     stands for the upper limit of 95% prediction interval */
run;

data new;
    set pred;
    x        = exp( lny );
    forecast = exp( p  );
    l95      = exp( l95 );
    u95      = exp( u95 );
 run;
title1 'Forecast of historical and future values of  monthly international tourist hotel room averages';
title2 'fitted time series regression';
 legend1  label=none value=('true' 'Predicted' '95% lower limit' '95% upper limit');
proc gplot data=new; 
   plot x*t=1  forecast*t=2  l95*t=3  u95* t=4  / overlay
      href= 168 legend=legend1;
   symbol1 i=join  v=dot  c=red ; 
   symbol2 i=join v=star  c=green ; 
   symbol3 i=join v=none  c=blue; 
   symbol4 i=join v=none  c=blue;   
run; 
title1 'Forecast of future values of  monthly international tourist hotel room averages';
title2 'fitted time series regression';
 legend2  label=none value=( 'Predicted' 'Lower limit of 95% prediction interval' 'Upper limit of 95% prediction interval');
proc gplot data=new; 
where 156 < t < 168; 
   plot   forecast*t=2  l95*t=3  u95* t=4  / overlay
      legend=legend2;
   symbol1 i=join  v=dot  c=red ; 
   symbol2 i=join v=star  c=green ; 
   symbol3 i=join v=none  c=blue; 
   symbol4 i=join v=none  c=blue;   
run; 
quit;

