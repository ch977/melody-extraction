    function [contSet,contTs]=detOcta(contSet,contTs,pchMfilt)
        
        len1=length(contSet);
        dupset=zeros(len1,4);
        t=1;
        for i=1:len1-1
            for j=i+1:len1
                if contSet{i}(1,1)<contSet{j}(1,1)&&contSet{i}(end,1)>contSet{j}(end,1)  %j belong to i
                    len_j=size(contSet{j},1);
                    m1=0;dist=0;
                    a_min=100000;a_max=1;
                    for k=1:len_j
                        a=find((contSet{i}(:,1)==contSet{j}(k,1)));
                        if a~=0
                            a=a(1);
                            if a<a_min
                                a_min=a;
                            end
                            if a>a_max
                                a_max=a;
                            end
                            dist=dist+abs(contSet{i}(a,2)-contSet{j}(k,2));
                            m1=m1+1;
                        end
                    end
                    mdist=dist/m1;
                    
                    
                    if mdist<125&&mdist>115         %mean distance within 1200+-50cents
                        dupset(t,:)=[j,i,a_min,a_max];    %first one is short
                        t=t+1;
                    end
                    
                elseif contSet{j}(1,1)<contSet{i}(1,1)&&contSet{j}(end,1)>contSet{i}(end,1)  %j belong to i
                    len_i=size(contSet{i},1);
                    m1=0;dist=0;
                    a_min=100000;a_max=1;
                    for k=1:len_i
                        a=find(contSet{j}(:,1)==contSet{i}(k,1));
                        
                        if numel(a)~=0
                            a=a(1);
                            if a<a_min
                                a_min=a;
                            end
                            if  a>a_max
                                a_max=a;
                            end
                            dist=dist+abs(contSet{j}(a,2)-contSet{i}(k,2));
                            m1=m1+1;
                        end
                    end
                    
                    mdist=dist/m1;
                    if mdist<125&&mdist>115         %mean distance within 1200+-50cents
                        dupset(t,:)=[i,j,a_min,a_max];    %first one is short
                        t=t+1;
                    end
                end
            end
        end
        
        dupset1=dupset(dupset(:,1)~=0,:);
        octaveErr=zeros(size(dupset1,1),1);
        octi=1;
        for i=1:size(dupset1,1)
            c1=dupset(i,1);
            c2=dupset(i,2);
            s2=dupset(i,3);
            e2=dupset(i,4);
            dupcont=contSet{c2}(s2:e2,:);
            s=contSet{c1}(1,1);
            e=contSet{c1}(end,1);
            %pm=pchMfilt(s2:e2,:);
            dist1=0;dist2=0;
            if (e-s+1)~=size(contSet{c1},1)
                for k=1:size(contSet{c1},1)
                    dist1=dist1+abs(pchMfilt(contSet{c1}(k,1))-contSet{c1}(k,2));
                end
            else
                dist1=sum(abs(contSet{c1}(:,2)-pchMfilt(s:e)));
            end
            
            if (e-s+1)~=size(dupcont,1)
                for k=1:size(dupcont,1)
                    dist2=dist2+abs(pchMfilt(dupcont(k,1))-dupcont(k,2));
                end
            else
                dist2=sum(abs(dupcont(:,2)-pchMfilt(s:e)));
            end
            
            if dist1<dist2
                octaveErr(octi)=c2;
            else
                octaveErr(octi)=c1;
            end
            octi=octi+1;
        end
        
        
        contSet(octaveErr)=[];  %remove the contour furthest from mean P(t)
        contTs(octaveErr)=[];
        %save results in detocta.mat  ,contSet:1515
    end