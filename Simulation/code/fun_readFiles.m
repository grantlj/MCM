function [ udata,uitem,userinfo ] = fun_readFiles( name1,name2,name3,name4)  %name 3: joblist.txt; %name 4: user.u

fid=fopen(name1);
[udata,~]=fscanf(fid,'%d');
udata=reshape(udata,3,length(udata)/3)';
fclose(fid);

fid=fopen(name2);
[uitem,~]=fscanf(fid,'%d');
uitem=reshape(uitem,19,length(uitem)/19)';
uitem(:,1)=[];
fclose(fid);

userinfo=TransferUserlist(name3,name4);
end

function [userinfo] = TransferUserlist(filename,name4)
%filename='joblist.txt';
fid=fopen(filename,'r');

%load job image file into jobs.
jobcount=0;
jobs={};
while (~feof(fid))
    line=fgetl(fid);
    jobcount=jobcount+1;
    jobs{jobcount}=line;
end
fclose(fid);

fid_user=fopen(name4,'r');

userinfo=[];
while (~feof(fid_user))
    line=fgetl(fid_user);
    s=regexp(line, '	', 'split');
    userinfo=[userinfo;str2num(s{1}),str2num(s{2}),searchJobId(s{3},jobs)];
end
fclose(fid_user);

end

function [id]=searchJobId(str,jobs)
  for i=1:size(jobs,2)
    if (strcmp(str,jobs{i}))
        id=i;break;
    end
  end

end
