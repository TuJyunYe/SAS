data price;

do year=2001 to 2014;
        do month=1 to 12;
input y ;
date=mdy(month,1,year);
t+1;
output;
       end;
end;
keep date y t;
        format date monyy5.;
label y='Average Room Price';
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

symbol1 v=star i=join c=red;
symbol2 v=star i=join c=green;
symbol3 v=star i=join c=blue;
symbol4 v=star i=join c=blue;


proc gplot;
plot  y*t;

title 'Exponential Smoothing';
proc forecast data=price interval=monthly lead=12 out=pred
outactual outlimit outest=est outfitstats
method=winters seasons=12 trend=2; /*  For seasonal data you may want to fit a Winters
exponentially smoothed trend-seasonal model with METHOD=WINTERS */
var y;
id date;
run;
proc print data=pred;
title "Forecasts from Holt-Winters' multiplicative method";
proc gplot data=pred; 
   plot y * date = _type_ / 
        haxis= '1jan01'd to '1jan16'd by year
        href='1jan15'd; 
   symbol1 i=join  v=star ; 
   symbol2 i=spline v=star ; 
   symbol3 i=spline l=3; 
   symbol4 i=spline l=3; 
   where date >= '1jan01'd; 
run; 
quit;
