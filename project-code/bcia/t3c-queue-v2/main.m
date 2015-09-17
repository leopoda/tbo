[posData] = Preprocessing('2015-08-15');
[GAT_T3_E,SCK_T3_E] = ReadSecurityData('20150811');
[securityTime,securityData,sck] = CalSecurityTime(GAT,SCK);
[preResult,passMac_all,securityResult,passTime,error] = Predicate_new(posData,securityData,secArea,5,1,10,0.5);




[posData,location_point] = DrawTrajectory(posData,passMac_all,secArea,num);