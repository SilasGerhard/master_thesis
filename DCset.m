function [flags,EC,settime] = DCset(client,cmd,value)

% This functions sends the respective command to the DC-source and reports the response of
% the source.

tott=tic;

flags=[false false false false];
settime=zeros(1,3);
EC=uint8(0);


switch cmd
    case 'HVon'
        message=uint8([2,'99,',3]);
    case 'HVoff'
        message=uint8([2,'98,',3]);
    case 'setC'
        data=uint16(value*(4095/2.3));
        str=append('11,',num2str(data),',');
        message=uint8([2,str,3]);
    case 'setV'
        data=uint16(value*(4095/130));
        str=append('10,',num2str(data),',');
        message=uint8([2,str,3]);
    case 'clearFaults'
        message=uint8([2,'52,',3]);
    otherwise
        flags(1,2)=true;
end


if flags(1,2)==false
    wt=tic;
    write(client,message);

    answer=char(readline(client));
    settime(1,2)=toc(wt);

    res=answer(1,5);

    switch res
        case '$'
            flags(1,1)=true;
        case '1'
            flags(1,3)=true;
            EC=uint8(1);
        case '!'
            flags(1,3)=true;
            EC=uint8(2);
        otherwise
            flags(1,4)=true;
    end
end


settime(1,1)=toc(tott);
settime(1,3)=settime(1,1)-settime(1,2);


end
