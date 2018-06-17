{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 resolution;\n\n// Mona Lisa in triangles - by Dave Hoskins 2013\n// Made with Shadertoy:- https://www.shadertoy.com/view/MsX3WH\n\n// This was done using ideas Roger Alsing presented in 2008\n// His blog:  http://rogeralsing.com/2008/12/07/genetic-programming-evolution-of-mona-lisa/\n\n\n// Add noise to the triangles to make it a little clearer...\n#define ADD_DITHER\n\nvec3 col = vec3(0.0);\nvec2 uv;\n#define INV_SCALE 1.0/vec2(512.0, 288.0)\nvec2 fcoord;\n\n#ifdef ADD_DITHER\nvec2 randValues = vec2(0.01, 0.01);\nvec2 Hash2( vec2 x )\n{\n    float n = dot(x,vec2(1.0,113.00));\n    return fract(sin(vec2(n,n+1.0))*vec2(3758.5233,2578.1459));\n}\n#endif\n\n\nvec2 unpackCoord(float f) \n{\n    vec2 coord;\n    coord.x = floor(mod(f, 512.0));\n    coord.y = floor(f / 512.0);\n    return coord * INV_SCALE;\n}\n\nvec2 unpackColour(float f) \n{\n    vec2 colour;\n    colour.x = floor(mod (f, 256.0));\n    colour.y = floor(f / 256.0);\n    return colour / 256.0;\n}\n\nvoid Tri(float pA, float pB, float pC, float pCol1, float pCol2)\n{\n\tvec2 pos = uv;\n\tvec2 a = unpackCoord(pA);\n\tvec2 b = unpackCoord(pB);\n\tvec2 c = unpackCoord(pC);\n#ifdef ADD_DITHER\n\tpos += Hash2(fcoord) * randValues.x - randValues.y;\n\tpos = clamp(pos, vec2(0.0001), vec2(.996));\n#endif\n\n\t// This is the smaller 2D triangle test I could find...\n\tfloat as_x = pos.x-a.x;\n    float as_y = pos.y-a.y;\n\tbool si = (b.x-a.x)*as_y-(b.y-a.y)*as_x > 0.0;\n    if ((c.x-a.x)*as_y-(c.y-a.y)*as_x > 0.0 == si) return;\n    if ((c.x-b.x)*(pos.y-b.y)-(c.y-b.y)*(pos.x-b.x) > 0.0 != si) return;\n\t// ...done triangle test! :)\n\t\n\tvec2 c1 = unpackColour(pCol1); // Don't use functions as variables in Windows\n\tvec2 c2 = unpackColour(pCol2); // So if I put unpackColour into the vec4 it breaks.\n\tvec4 triCol = vec4(c1, c2);\n\tcol = mix (col, triCol.rgb, triCol.a); \n}\n\nvoid main()\n{\n    fcoord = gl_FragCoord.xy;\n\tuv = fcoord / resolution.xy;\n\tTri(113981.0, 10049.0,273.0, 58787.0, 3720.0);\n\tTri(23756.0, 21755.0,15595.0, 64507.0, 15350.0);\n\tTri(91962.0, 70504.0,46344.0, 62715.0, 15338.0);\n\tTri(23801.0, 24221.0,16122.0, 62972.0, 15334.0);\n\tTri(122620.0, 124177.0,46213.0, 32275.0, 13246.0);\n\tTri(96768.0, 147019.0,146944.0, 65277.0, 15349.0);\n\tTri(88180.0, 46291.0,94092.0, 64248.0, 14935.0);\n\tTri(56162.0, 29454.0,63758.0, 55793.0, 15267.0);\n\tTri(367.0, 38241.0,6025.0, 7429.0, 7755.0);\n\tTri(112227.0, 65538.0,123472.0, 42163.0, 12090.0);\n\tTri(41995.0, 93334.0,5668.0, 17476.0, 7737.0);\n\tTri(20480.0, 28185.0,37888.0, 13830.0, 4559.0);\n\tTri(66705.0, 81054.0,135013.0, 63118.0, 15288.0);\n\tTri(141666.0, 146074.0,123239.0, 43930.0, 15354.0);\n\tTri(128923.0, 36856.0,128923.0, 10267.0, 11031.0);\n\tTri(100242.0, 106898.0,136814.0, 40349.0, 9761.0);\n\tTri(47964.0, 55942.0,104835.0, 61182.0, 15217.0);\n\tTri(56454.0, 97912.0,71928.0, 65278.0, 15218.0);\n\tTri(147356.0, 79250.0,146952.0, 7873.0, 7944.0);\n\tTri(89956.0, 91290.0,58503.0, 65022.0, 15357.0);\n\tTri(136094.0, 94226.0,102415.0, 19293.0, 15168.0);\n\tTri(127876.0, 135021.0,88231.0, 55289.0, 11616.0);\n\tTri(80791.0, 106817.0,85918.0, 29023.0, 12904.0);\n\tTri(60928.0, 146944.0,147035.0, 64766.0, 15200.0);\n\tTri(111323.0, 111670.0,116062.0, 49635.0, 7793.0);\n\tTri(1883.0, 115381.0,36233.0, 50641.0, 8205.0);\n\tTri(51326.0, 118080.0,29318.0, 63478.0, 2590.0);\n\tTri(60455.0, 85559.0,91172.0, 64219.0, 15246.0);\n\tTri(64247.0, 115418.0,71365.0, 59118.0, 15358.0);\n\tTri(12105.0, 20623.0,120610.0, 37628.0, 14612.0);\n\tTri(111229.0, 147077.0,147321.0, 53246.0, 15200.0);\n\tTri(146944.0, 62518.0,147012.0, 65011.0, 15266.0);\n\tTri(58589.0, 58579.0,57856.0, 64243.0, 15307.0);\n\tTri(29184.0, 126042.0,28688.0, 27489.0, 15173.0);\n\tTri(34479.0, 8407.0,27791.0, 53752.0, 14696.0);\n\tTri(99962.0, 49348.0,106626.0, 54599.0, 13788.0);\n\tTri(87940.0, 31972.0,28947.0, 35830.0, 15168.0);\n\tTri(143492.0, 129295.0,147136.0, 20905.0, 12739.0);\n\tTri(88798.0, 147131.0,95990.0, 63997.0, 14607.0);\n\tTri(48905.0, 42306.0,91964.0, 65017.0, 14589.0);\n\tTri(147109.0, 108757.0,147232.0, 64191.0, 15089.0);\n\tTri(97173.0, 26888.0,113355.0, 54268.0, 14134.0);\n\tTri(24597.0, 25154.0,4170.0, 36948.0, 5722.0);\n\tTri(116072.0, 115546.0,128283.0, 50426.0, 13675.0);\n\tTri(81649.0, 147325.0,147063.0, 37374.0, 14344.0);\n\tTri(86369.0, 87833.0,71478.0, 63802.0, 15357.0);\n\tTri(95232.0, 121923.0,139776.0, 62713.0, 14759.0);\n\tTri(99992.0, 99519.0,93864.0, 64253.0, 15342.0);\n\tTri(119808.0, 94304.0,57908.0, 58827.0, 12153.0);\n\tTri(123828.0, 123828.0,114723.0, 23888.0, 7965.0);\n\tTri(89163.0, 120929.0,81503.0, 2668.0, 13095.0);\n\tTri(147247.0, 147091.0,125587.0, 54009.0, 14840.0);\n\tTri(122458.0, 102478.0,115790.0, 27546.0, 13626.0);\n\tTri(87781.0, 104307.0,104263.0, 53240.0, 15298.0);\n\tTri(147081.0, 147256.0,9023.0, 42488.0, 11817.0);\n\tTri(60221.0, 51399.0,116516.0, 65277.0, 15278.0);\n\tTri(68673.0, 62018.0,83489.0, 27794.0, 9484.0);\n\tTri(19143.0, 18169.0,86156.0, 49913.0, 15217.0);\n\tTri(62216.0, 122754.0,38167.0, 55004.0, 8656.0);\n\tTri(139103.0, 141130.0,128355.0, 46269.0, 11500.0);\n\tTri(30041.0, 99590.0,11575.0, 45233.0, 13742.0);\n\tTri(105366.0, 85217.0,116619.0, 57853.0, 13641.0);\n\tTri(70334.0, 34499.0,37037.0, 64757.0, 14763.0);\n\tTri(105873.0, 113034.0,109945.0, 55797.0, 13386.0);\n\tTri(59025.0, 116297.0,60450.0, 2347.0, 14854.0);\n\tTri(6443.0, 109910.0,283.0, 46838.0, 3543.0);\n\tTri(70481.0, 146952.0,41932.0, 32426.0, 13465.0);\n\tTri(32628.0, 35706.0,26994.0, 58351.0, 9523.0);\n\tTri(147391.0, 98132.0,109854.0, 3334.0, 14868.0);\n\tTri(111372.0, 112970.0,139159.0, 53238.0, 12401.0);\n\tTri(55805.0, 55805.0,64810.0, 56591.0, 10462.0);\n\tTri(28549.0, 2719.0,365.0, 65012.0, 2983.0);\n\tTri(49.0, 8234.0,7.0, 64507.0, 4292.0);\n\tTri(98608.0, 46344.0,41710.0, 259.0, 13829.0);\n\tTri(71276.0, 94020.0,104178.0, 14635.0, 14336.0);\n\tTri(3923.0, 23418.0,12523.0, 20324.0, 14597.0);\n\tTri(40830.0, 6508.0,141205.0, 25972.0, 15142.0);\n\tTri(125017.0, 29184.0,146944.0, 60145.0, 12430.0);\n\tTri(147326.0, 129660.0,118664.0, 47353.0, 15166.0);\n\tTri(67358.0, 95122.0,21285.0, 36299.0, 13057.0);\n\tTri(118553.0, 63828.0,69386.0, 60670.0, 14514.0);\n\tTri(19456.0, 14352.0,0.0, 24146.0, 13380.0);\n\tTri(10087.0, 91521.0,64739.0, 31979.0, 14100.0);\n\tTri(11615.0, 38253.0,2441.0, 9510.0, 14872.0);\n\tTri(110808.0, 44752.0,90857.0, 64984.0, 14842.0);\n\tTri(147455.0, 142459.0,104944.0, 24203.0, 7775.0);\n\tTri(92988.0, 146558.0,68726.0, 12259.0, 10247.0);\n\tTri(35842.0, 42029.0,4142.0, 64159.0, 3457.0);\n\tTri(125612.0, 143002.0,116353.0, 54782.0, 12737.0);\n\tTri(115271.0, 146443.0,134736.0, 43990.0, 14912.0);\n\tTri(146944.0, 147033.0,84992.0, 64766.0, 15036.0);\n\tTri(137373.0, 55475.0,146570.0, 39412.0, 7811.0);\n\tTri(60124.0, 74938.0,147246.0, 1.0, 15104.0);\n\tTri(136152.0, 146394.0,147402.0, 15948.0, 7744.0);\n\tTri(16019.0, 109180.0,262.0, 38132.0, 13876.0);\n\tTri(142743.0, 147091.0,111420.0, 47346.0, 11607.0);\n\tTri(48350.0, 79593.0,76023.0, 54270.0, 13565.0);\n\tTri(111486.0, 85809.0,39223.0, 56047.0, 12896.0);\n\tTri(90253.0, 91513.0,11101.0, 52732.0, 13163.0);\n\tTri(121724.0, 1269.0,7052.0, 33272.0, 10001.0);\n\tTri(67207.0, 101582.0,41629.0, 40623.0, 15310.0);\n\tTri(147304.0, 123708.0,147177.0, 46842.0, 14975.0);\n\tTri(13363.0, 3659.0,136500.0, 5922.0, 15131.0);\n\tTri(146687.0, 53892.0,27346.0, 62205.0, 13486.0);\n\tTri(145054.0, 120591.0,121461.0, 46317.0, 12363.0);\n\tTri(132949.0, 147298.0,135558.0, 46070.0, 10836.0);\n\tTri(43252.0, 42258.0,27394.0, 56825.0, 15162.0);\n\tTri(96354.0, 117334.0,93231.0, 42487.0, 8042.0);\n\tTri(109133.0, 147029.0,133122.0, 42194.0, 15176.0);\n\tTri(105082.0, 83847.0,6315.0, 49405.0, 11405.0);\n\tTri(65757.0, 90303.0,105190.0, 58543.0, 15080.0);\n\tTri(147350.0, 82339.0,147239.0, 56310.0, 3081.0);\n\tTri(85194.0, 46289.0,50378.0, 65021.0, 14571.0);\n\tTri(146552.0, 110779.0,111262.0, 43262.0, 15157.0);\n\tTri(146943.0, 119285.0,113663.0, 40446.0, 2764.0);\n\tTri(49824.0, 29998.0,28357.0, 64766.0, 15270.0);\n\tTri(97441.0, 130060.0,52776.0, 24721.0, 7748.0);\n\tTri(9919.0, 23271.0,27787.0, 62717.0, 14506.0);\n\tTri(147066.0, 112250.0,147296.0, 61438.0, 14996.0);\n\tTri(511.0, 305.0,127487.0, 40692.0, 3253.0);\n\tTri(147333.0, 75156.0,120432.0, 28663.0, 8964.0);\n\tTri(146217.0, 136030.0,131241.0, 41379.0, 15218.0);\n\tTri(22479.0, 13229.0,38354.0, 7983.0, 8741.0);\n\tTri(855.0, 86379.0,136700.0, 10798.0, 11056.0);\n\tTri(132873.0, 38058.0,147152.0, 40957.0, 15139.0);\n\tTri(71803.0, 99203.0,26762.0, 48125.0, 10106.0);\n\tTri(102275.0, 97622.0,84857.0, 39599.0, 13985.0);\n\tTri(10908.0, 131816.0,226.0, 54525.0, 14942.0);\n\tTri(119092.0, 69504.0,94108.0, 56827.0, 4197.0);\n\tTri(15162.0, 27824.0,38033.0, 519.0, 15105.0);\n\tTri(96564.0, 70954.0,106312.0, 30395.0, 7764.0);\n\tTri(47052.0, 64968.0,56291.0, 11835.0, 8726.0);\n\tTri(99075.0, 95998.0,82863.0, 15705.0, 9989.0);\n\tTri(58770.0, 112027.0,84102.0, 46837.0, 9796.0);\n\tTri(82682.0, 32986.0,68953.0, 6.0, 10765.0);\n\tTri(105149.0, 28507.0,100015.0, 35266.0, 15185.0);\n\tTri(69253.0, 75407.0,4790.0, 54263.0, 10971.0);\n\tTri(82434.0, 141855.0,78364.0, 61665.0, 13779.0);\n\tTri(147010.0, 130560.0,72235.0, 65266.0, 15283.0);\n\tTri(82944.0, 102912.0,60039.0, 6704.0, 15105.0);\n\tTri(45325.0, 139518.0,34009.0, 518.0, 15104.0);\n\tTri(9584.0, 22392.0,11089.0, 51451.0, 7756.0);\n\tTri(86461.0, 112558.0,104924.0, 9247.0, 14378.0);\n\tTri(87264.0, 89287.0,81601.0, 16284.0, 15112.0);\n\tTri(93031.0, 61241.0,87825.0, 64718.0, 15064.0);\n\tTri(29213.0, 54322.0,145430.0, 25105.0, 4422.0);\n\tTri(103480.0, 132158.0,24754.0, 1291.0, 13828.0);\n\tTri(89100.0, 78849.0,57870.0, 42702.0, 10086.0);\n\tTri(135185.0, 146975.0,147020.0, 63998.0, 14253.0);\n\tTri(41233.0, 23806.0,71436.0, 9531.0, 14850.0);\n\tTri(121739.0, 120111.0,105822.0, 6930.0, 14111.0);\n\tTri(18183.0, 23297.0,22797.0, 60387.0, 14945.0);\n\tTri(190.0, 387.0,19607.0, 34041.0, 15125.0);\n\tTri(102477.0, 108392.0,141311.0, 768.0, 10240.0);\n\tTri(336.0, 99672.0,195.0, 51707.0, 15211.0);\n\tTri(115342.0, 125113.0,112338.0, 8461.0, 14081.0);\n\tTri(5101.0, 64220.0,5101.0, 27380.0, 14229.0);\n\tTri(71244.0, 16384.0,68608.0, 5399.0, 15122.0);\n\tTri(3577.0, 3577.0,147329.0, 48643.0, 8866.0);\n\tTri(133079.0, 84392.0,133079.0, 61058.0, 13261.0);\n\tTri(2818.0, 8549.0,383.0, 13092.0, 7972.0);\n\tTri(193.0, 263.0,12995.0, 65277.0, 15296.0);\n\tTri(50370.0, 50953.0,24828.0, 257.0, 15104.0);\n\tTri(180.0, 35981.0,325.0, 53246.0, 15183.0);\n\tTri(125091.0, 66008.0,94531.0, 22277.0, 8327.0);\n\tTri(147191.0, 116408.0,134016.0, 50424.0, 12659.0);\n\tTri(79065.0, 98055.0,79111.0, 36056.0, 14597.0);\n\tTri(95635.0, 119702.0,53090.0, 23931.0, 15104.0);\n\tTri(98304.0, 147382.0,146944.0, 51452.0, 7815.0);\n\tTri(75221.0, 3786.0,120769.0, 5420.0, 10501.0);\n\tTri(115257.0, 91682.0,87621.0, 54498.0, 15236.0);\n\tTri(75369.0, 78893.0,59489.0, 13897.0, 9043.0);\n\tTri(191.0, 58505.0,1931.0, 41982.0, 11299.0);\n\tTri(125069.0, 137084.0,147263.0, 46304.0, 15224.0);\n\tTri(16535.0, 16683.0,31574.0, 48377.0, 14699.0);\n\tTri(16961.0, 6706.0,20021.0, 30397.0, 3981.0);\n\tTri(109942.0, 112412.0,100146.0, 2.0, 14861.0);\n\tTri(73983.0, 37151.0,112010.0, 61180.0, 10690.0);\n\tTri(78220.0, 372.0,117062.0, 23172.0, 10764.0);\n\tTri(75436.0, 58017.0,77471.0, 31511.0, 10129.0);\n\tTri(44749.0, 54964.0,99540.0, 4700.0, 14593.0);\n\tTri(112808.0, 13992.0,84595.0, 42212.0, 15203.0);\n\tTri(86777.0, 46809.0,92277.0, 59357.0, 13533.0);\n\tTri(10575.0, 14682.0,18771.0, 45270.0, 14638.0);\n\tTri(68259.0, 33013.0,44239.0, 7491.0, 15106.0);\n\tTri(143105.0, 123636.0,129806.0, 49145.0, 14924.0);\n\tTri(46105.0, 94873.0,147045.0, 512.0, 15108.0);\n\tTri(22159.0, 103838.0,101493.0, 49150.0, 13906.0);\n\tTri(29065.0, 306.0,397.0, 8205.0, 15124.0);\n\tTri(2569.0, 24595.0,2586.0, 9751.0, 14879.0);\n\tTri(185.0, 107133.0,254.0, 54269.0, 14209.0);\n\tTri(33070.0, 25363.0,24092.0, 20.0, 14338.0);\n\tTri(104569.0, 11929.0,87848.0, 43258.0, 10804.0);\n\tTri(76852.0, 74794.0,129044.0, 53455.0, 9612.0);\n\tTri(133864.0, 53333.0,134377.0, 57334.0, 13716.0);\n\tTri(147337.0, 147106.0,108950.0, 52989.0, 12618.0);\n\tTri(54969.0, 52911.0,60594.0, 21099.0, 7704.0);\n\tTri(79907.0, 145989.0,67146.0, 33431.0, 12596.0);\n\tTri(84708.0, 65249.0,48886.0, 4703.0, 8456.0);\n\tTri(129716.0, 127202.0,103560.0, 34504.0, 13389.0);\n\tTri(54.0, 1.0,21014.0, 65011.0, 6000.0);\n\tTri(102436.0, 60928.0,75304.0, 19523.0, 14884.0);\n\tTri(143001.0, 136360.0,135310.0, 25483.0, 14450.0);\n\tTri(74981.0, 51470.0,74000.0, 29111.0, 13612.0);\n\tTri(106240.0, 101177.0,94475.0, 58110.0, 14991.0);\n\tTri(102533.0, 147057.0,105528.0, 258.0, 15108.0);\n\tTri(99844.0, 43583.0,55409.0, 5148.0, 12043.0);\n\tTri(0.0, 55829.0,300.0, 41722.0, 3012.0);\n\tTri(43344.0, 36027.0,24283.0, 41460.0, 14390.0);\n\tTri(51615.0, 108543.0,62463.0, 10287.0, 7971.0);\n\tTri(52347.0, 51937.0,147063.0, 46331.0, 11085.0);\n\tTri(147189.0, 77544.0,147124.0, 60414.0, 12946.0);\n\tTri(60248.0, 92525.0,29426.0, 39387.0, 14458.0);\n\tTri(122243.0, 59178.0,67472.0, 43260.0, 9779.0);\n\tTri(15507.0, 32959.0,185.0, 15717.0, 13575.0);\n\tTri(59276.0, 318.0,896.0, 9283.0, 14861.0);\n\tTri(57228.0, 95860.0,54399.0, 51959.0, 8071.0);\n\tTri(109906.0, 115477.0,117569.0, 65264.0, 15283.0);\n\tTri(191.0, 11530.0,274.0, 61182.0, 15245.0);\n\tTri(59644.0, 133898.0,103655.0, 9027.0, 12032.0);\n\tTri(61217.0, 50939.0,62169.0, 42489.0, 14912.0);\n\tTri(69757.0, 41607.0,65707.0, 33500.0, 14662.0);\n\tTri(204.0, 5796.0,94836.0, 32712.0, 14906.0);\n\tTri(60661.0, 62223.0,82687.0, 42697.0, 8725.0);\n\tTri(42230.0, 9496.0,39137.0, 19309.0, 13845.0);\n\tTri(8435.0, 68983.0,11472.0, 8765.0, 14337.0);\n\tTri(116625.0, 111023.0,376.0, 7473.0, 15122.0);\n\tTri(22735.0, 25947.0,2870.0, 47612.0, 13391.0);\n\tTri(3886.0, 76033.0,114564.0, 54269.0, 9876.0);\n\tTri(119777.0, 82328.0,114647.0, 43132.0, 10468.0);\n\tTri(107015.0, 70183.0,92672.0, 18753.0, 11271.0);\n\tTri(44743.0, 43623.0,43599.0, 31650.0, 14599.0);\n\tTri(37096.0, 11481.0,9961.0, 18843.0, 11264.0);\n\tTri(276.0, 36998.0,69240.0, 11901.0, 8195.0);\n\tTri(98757.0, 147337.0,93061.0, 10824.0, 11310.0);\n\tTri(24989.0, 43911.0,6028.0, 29401.0, 4411.0);\n\tTri(64773.0, 301.0,113064.0, 40683.0, 7994.0);\n\tTri(90947.0, 98659.0,134957.0, 10856.0, 12550.0);\n\tTri(32768.0, 0.0,86.0, 39556.0, 11080.0);\n\tTri(115886.0, 109709.0,110278.0, 65277.0, 15313.0);\n\tTri(97838.0, 23734.0,54300.0, 23764.0, 2736.0);\n\tTri(61603.0, 147344.0,147068.0, 55548.0, 7782.0);\n\tTri(103642.0, 147251.0,147083.0, 57597.0, 13199.0);\n\tTri(96944.0, 89735.0,107680.0, 55549.0, 15234.0);\n\tTri(81028.0, 68256.0,82078.0, 19292.0, 6475.0);\n\tTri(130923.0, 35701.0,32158.0, 36306.0, 3909.0);\n\tTri(42355.0, 42355.0,135795.0, 1513.0, 12776.0);\n\tTri(82408.0, 119798.0,125707.0, 2310.0, 3081.0);\n\tTri(94351.0, 99023.0,87734.0, 10340.0, 13313.0);\n\tTri(137850.0, 135541.0,124062.0, 48869.0, 12655.0);\n\tTri(130927.0, 119589.0,142081.0, 44782.0, 13661.0);\n\tTri(98941.0, 107403.0,16751.0, 49657.0, 11594.0);\n\tTri(143147.0, 127287.0,135450.0, 54012.0, 14990.0);\n\tTri(114251.0, 126570.0,147027.0, 7747.0, 14623.0);\n\tTri(12957.0, 62670.0,38535.0, 28576.0, 11816.0);\n\tTri(8458.0, 133390.0,88802.0, 1080.0, 8707.0);\n\n\tgl_FragColor = vec4(col, 1.0 );\n}\n\n", "user": "4357062", "parent": "/e#25398.0", "id": "25424.0"}