 data price;
    input x ;
    time=_n_;
    date = intnx( 'month', '31dec2000'd, _n_ );
    format date monyy.;
sdiff=x-lag12(x);
d1=x-lag(x);
diff=d1-lag12(d1);
p1 =( time = 28);
p2 =( time = 133);
p3 =( time = 146);
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
		  
 symbol1 i=join  v=star c=red; 
symbol2  i=join  v=star c=blue;
symbol3  i=join  v=none c=green;
symbol4  i=join  v=star c=pink;
title1 'International Tourist Hotel - Average Room price (10NT$/night)';
 proc gplot data=price;
    plot (x ) * date = 1 /href='01Apr03'd  href='01Jan12'd  href='01Feb13'd    haxis= '01Jan01'd to '01Jan15'd by year;
	plot x *time =2 ;
	plot (d1 sdiff diff)*time = 2 ;
proc arima data=price;
identify var=x crosscorr=(p1 p2 p3) nlag=24;
identify var=x(1) crosscorr=(p1(1) p2(1) p3(1)) nlag=24;
identify var=x(12) crosscorr=(p1(12) p2(12) p3(12)) nlag=24;
identify var=x(1,12) crosscorr=(p1(1,12) p2(1,12) p3(1,12)) nlag=24;
estimate p=(12)  q=(1) input=(0$/(1)p1 p2 p3) noconstant method=ml plot;
forecast lead=12 out=fcast1;
run;
data for;
merge price fcast1;
/* proc print  */
	title 'Forecasts and 95% prediction intervals for historical and fututre values' ;
	 legend1  label=none value=('true' 'Predicted' '95% lower limit' '95% upper limit');
proc gplot data=for;
plot  x*time=1
        forecast*time=2
         l95*time=3  u95*time=3 /overlay href=156 href=168  legend=legend1;
	title 'Forecasts and 95% prediction intervals for the future values ' ;
	 legend2  label=none value=( 'Predicted' '95% lower limit' '95% upper limit');
proc gplot;
    where time >= 168;
    plot forecast* time = 1
      l95* time=2 u95* time= 3 /
         overlay haxis= 168 to 180  legend=legend2;


run;
quit;
