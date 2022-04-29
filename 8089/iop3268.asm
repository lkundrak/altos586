3268: 51 30 d0 ff               movi    gc,0ffd0h
326c: aa bb 04 20               jnbt    [pp].4h,5,x3290
3270: 0a 4e 06 80               movbi   [gc].6h,80h
3274: 02 93 08 02 ce 02         movb    [gc].2h,[pp].8h
327a: ea ba 06 fc       x327a:  jnbt    [gc].6h,7,x327a
327e: 0a 4e 06 20               movbi   [gc].6h,20h
3282: 13 4f 14 00 00            movi    [pp].14h,0h
3287: 0a be 06 fc       x3287:  jbt     [gc].6h,0,x3287
328b: 12 ba 04 e2 00            ljnbt   [gc].4h,0,x3372
3290: 0a cb 04 0f       x3290:  andbi   [pp].4h,0fh
3294: 12 e7 04 b1 00            ljzb    [pp].4h,x334a
3299: 02 93 08 02 ce 02         movb    [gc].2h,[pp].8h
329f: ea ba 06 fc       x329f:  jnbt    [gc].6h,7,x329f
32a3: 02 93 14 00 ce            movb    [gc],[pp].14h
32a8: 02 93 15 00 ce            movb    [gc],[pp].15h
32ad: 02 93 06 02 ce 04         movb    [gc].4h,[pp].6h
32b3: 02 93 07 02 ce 04         movb    [gc].4h,[pp].7h
32b9: 0a 4e 06 10               movbi   [gc].6h,10h
32bd: 03 93 06 03 cf 14         mov     [pp].14h,[pp].6h
32c3: 0a be 06 fc       x32c3:  jbt     [gc].6h,0,x32c3
32c7: 2a ba 04 fc       x32c7:  jnbt    [gc].4h,1,x32c7
32cb: 0a e7 10 7b               jzb     [pp].10h,x334a
32cf: 0a bf 04 0e               jbt     [pp].4h,0,x32e1
32d3: 03 8b 0c                  lpd     ga,[pp].0ch
32d6: 31 30 00 00               movi    gb,0h
32da: 63 83 0a                  mov     bc,[pp].0ah
32dd: 8b 9f 16 70               call    [pp].16h,x3351
32e1: 31 30 00 00       x32e1:  movi    gb,0h
32e5: f1 30 80 fe               movi    mc,0fe80h
32e9: 11 30 d0 ff               movi    ga,0ffd0h
32ed: 13 4f 12 00 02            movi    [pp].12h,200h
32f2: 0a bb 04 12               jnbt    [pp].4h,0,x3308
32f6: d1 30 28 8a               movi    cc,8a28h
32fa: a0 00                     wid     8,16
32fc: 6a bb 04 17               jnbt    [pp].4h,3,x3317
3300: 13 4f 12 05 02            movi    [pp].12h,205h
3305: 88 20 0f                  jmp     x3317
3308: d1 30 28 56       x3308:  movi    cc,5628h
330c: c0 00                     wid     16,8
330e: 4a bb 04 05               jnbt    [pp].4h,2,x3317
3312: 13 4f 12 04 00            movi    [pp].12h,4h
3317: 63 83 12          x3317:  mov     bc,[pp].12h
331a: 02 93 09 00 ce            movb    [gc],[pp].9h
331f: 60 00                     xfer    
3321: 02 93 04 02 ce 06         movb    [gc].6h,[pp].4h
3327: 0a b6 06 33               jmcne   [gc].6h,x335e
332b: 02 ef 10                  decb    [pp].10h
332e: 0a e7 10 06               jzb     [pp].10h,x3338
3332: 02 eb 09                  incb    [pp].9h
3335: 88 20 df                  jmp     x3317
3338: 0a bb 04 0e       x3338:  jnbt    [pp].4h,0,x334a
333c: 23 8b 0c                  lpd     gb,[pp].0ch
333f: 11 30 00 00               movi    ga,0h
3343: 63 83 0a                  mov     bc,[pp].0ah
3346: 8b 9f 16 07               call    [pp].16h,x3351
334a: 0a 4f 05 00       x334a:  movbi   [pp].5h,0h
334e: 88 20 26                  jmp     x3377
3351: e0 00             x3351:  wid     16,16
3353: d1 30 08 c2               movi    cc,0c208h
3357: 60 00                     xfer    
3359: 00 00                     nop     
335b: 83 8f 16                  movp    tp,[pp].16h
335e: 02 92 06 02 cf 05 x335e:  movb    [pp].5h,[gc].6h
3364: 0a cb 05 7e               andbi   [pp].5h,7eh
3368: e2 f7 05                  setb    [pp].5h,7
336b: 0a 4e 06 00               movbi   [gc].6h,0h
336f: 88 20 05                  jmp     x3377
3372: 13 4f 05 81 00    x3372:  movi    [pp].5h,81h
3377: 40 00             x3377:  sintr   
