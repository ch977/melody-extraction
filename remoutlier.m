    function [contSet,contTs]=remoutlier(contSet,contTs,pchmean)
        
        ncont=length(contSet);
        t=1;
        outlier=zeros(ncont,1);
        dist=0;
        for i=1:ncont
            s=contSet{i}(1,1);
            e=contSet{i}(end,1);
            
            
            if (s-e+1)==size(contSet{i},1)
                dist=sum(abs(contSet{i}(:,2)-pchmean(s:e)));
            else
                for k=1:size(contSet{i},1)
                    dist=dist+abs(pchmean(contSet{i}(k,1))-contSet{i}(k,2));
                end
            end
            dist=dist/size(contSet{i},1);
            
            if dist>115   %outliers:more than one octave from mean p
                outlier(t)=i;
                t=t+1;
            end
        end
        
        id=find(outlier==0);
        outlier(id:end)=[];
        contSet(outlier)=[];
        contTs(outlier)=[];
    end