data price;
do year =2001 to 2014;
        do month=1 to 12;
input price ;
date=mdy(month,1,year);
t+1;
output;
       end;
end;
keep date price  t;
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
;

symbol1 v=dot i=join c=red;
symbol2 v=star i=join c=green;
symbol3 v=star i=join c=blue;
title1 'International Tourist Hotel - Average Room price (10NT$/night)';
proc gplot;
plot  price  *date;
proc x11 data=price  yraheadout;
monthly date=date;    /* tdregr=none test;   */
tables b1 d10 d11 d12 d13;
output out=comp b1=y d10=sn d11=dy d12=trc d13=ir;
var price; 
run;
/*   For the standard X-11 method, there must be at least three years of observations  in the input data sets. 
For the X-11-ARIMA method, there must be at least five years of observations  in the input data sets. 

For monthly data, the YRAHEADOUT option affects only tables C16, C18, and D10 (seasonal factors).
For quarterly data, only D10 is affected. Variables for all other tables have missing values for the forecast observations. 
The forecast values for a table are included only if that table is specified in the OUTPUT statement. 
If the input data are monthly time series, 12 extra observations are added to the end of the output data set.

b1: the observed time series
d10: the seasonal component 
d11: deseasonalized observations
d12: trend-cycle component 
d13: the irregular component 
*/

data price2;  /* cola2: change scales of sn and ir compoents */
merge price  comp;
t=_n_;
sn=sn/100;
ir=ir/100;
proc print data=price2;
run;
title1 'Time plot of deseasonalized of International Tourist Hotel ';

 legend1 label=none value=('original' 'deseasonalized');
proc gplot;
plot (y dy)*t  /overlay legend=legend1 haxis=0 to 168 by 5;
run;
/* time series plots for  trc, sn, and ir compoents */
title ' Trend-cycle component ';
proc gplot;
plot trc *t /haxis=0 to 168 by 5;
run;
title ' Seasonal component ';
proc gplot;
plot sn *t/href=168; 
run;
title ' Irregular component ';
proc gplot;
plot ir *t; 
run;

proc print data=comp;
run;
proc reg data=price2;
model dy= t /p DW; /* P=predictions DW=Durbin-Watson Statistic */
output out=all p=tr;
run;
run;
proc autoreg data=price2;
model dy=t/nlag=2 dw=1 dwprob;
output out=for1     /* All  outputs are  saved in for1 */
p=predict ucl=u95 lcl=l95;
run;
title1 'Estimate of trend obtained from a regression with AR(2) errors';
 legend2  label=none value=('trend-cycle' 'Predicted');
proc gplot;
plot ( trc predict) *t /overlay haxis=0 to 180 by 5 legend=legend2;
run;
data price3;   /*cola3 : merge all variables in cola2 and for1*/
merge price2 for1;
for=predict*sn;
l95=l95*sn;
u95=u95*sn;
proc print data=price3;
run;
title1 'Forecasts of historical and future values of International Tourist Hotel ';
title2 'Estimate of trend obtained from a regression model';
 legend3  label=none value=('original' 'Forecasts');
proc gplot data=price3;
plot y* t =1  for *t=2  /overlay legend=legend3  href=168;
run;
title1 'Forecasts of historical and future values of International Tourist Hotel';
title2 'Estimate of trend obtained from a regression with AR(2) errors';
 legend4  label=none value=('original' 'Forecasts' '95% lower limit' '95% upper limit');
proc gplot;
plot y*t=1  for*t=2 l95*t=3 u95*t=3/ overlay  legend=legend4 href=36;
run;
title1 ' Forecasts of future values of International Tourist Hotel ';
title2 'Estimate of trend obtained from a regression with AR(2) errors';
 legend5  label=none value=( 'Forecasts' '95% lower limit' '95% upper limit');
proc gplot data=price3;
where t > 168;
plot for*t= 1  l95*t=3 u95*t =3/overlay  legend=legend5;
run;
quit;
