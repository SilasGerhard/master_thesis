function [status,checktime] = DCcheck(client)

% This function checks all output information of the DC-source.

tott=tic;

status=cell(1,7);
checktime=zeros(1,8);


% Check voltage setpoint

vst=tic;
write(client,uint8([2,'14,',3]));

answer=char(readline(client));
checktime(1,2)=toc(vst);
i=5;
while strcmp(answer(1,i),',')==0
i=i+1;
end

status{1,1} = uint16(str2double(answer(1,5:(i-1))));


% Check current setpoint

cst=tic;
write(client,uint8([2,'15,',3]));

answer=char(readline(client));
checktime(1,3)=toc(cst);
i=5;
while strcmp(answer(1,i),',')==0
i=i+1;
end

status{1,2} = uint16(str2double(answer(1,5:(i-1))));


% Check HV status

HVt=tic;
write(client,uint8([2,'22,',3]));

answer=char(readline(client));
checktime(1,4)=toc(HVt);

status{1,3} = logical(str2double(answer(1,5)));


% Check operation mode

omt=tic;
write(client,uint8([2,'69,',3]));

answer=char(readline(client));
checktime(1,5)=toc(omt);

status{1,4}(1,1:2) = [logical(str2double(answer(1,5))),logical(str2double(answer(1,7)))];


% Check system status

sst=tic;
write(client,uint8([2,'32,',3]));

answer=char(readline(client));
checktime(1,6)=toc(sst);

status{1,5}(1,1:11) = [logical(str2double(answer(1,5))),logical(str2double(answer(1,7))),logical(str2double(answer(1,9))),logical(str2double(answer(1,11))),logical(str2double(answer(1,13))),logical(str2double(answer(1,15))),logical(str2double(answer(1,17))),logical(str2double(answer(1,19))),logical(str2double(answer(1,21))),logical(str2double(answer(1,23))),logical(str2double(answer(1,25)))];


% Check measurements

mt=tic;
write(client,uint8([2,'20,',3]));

answer=char(readline(client));
checktime(1,7)=toc(mt);
j=5;
i=5;
for m=1:1:9
while strcmp(answer(1,i),',')==0
i=i+1;
end
status{1,6}(1,m) = uint16(str2double(answer(1,j:(i-1))));
i=i+1;
j=i;
end

status{1,7}(1,1) = double(status{1,6}(1,1))*(130/3983);
status{1,7}(1,2) = double(status{1,6}(1,2))*(2.3/3983);
status{1,7}(1,4) = double(status{1,6}(1,4))*(24/3246);
status{1,7}(1,5) = double(status{1,6}(1,5))*(15/2028);
status{1,7}(1,6) = double(status{1,6}(1,6))*(10/1353);
status{1,7}(1,7) = double(status{1,6}(1,7))*(5/3412);
status{1,7}(1,8) = double(status{1,6}(1,8))*(3.3/2252);
status{1,7}(1,9) = double(status{1,6}(1,9))*(-130/3983);


checktime(1,1)=toc(tott);
checktime(1,8)=checktime(1,1)-sum(checktime(1,2:7));


end
