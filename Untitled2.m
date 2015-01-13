n1=length(contSet2);
cont=zeros(nFrame,n1);
salience=zeros(nFrame,n1);
for p=1:n1
    cont(contSet2{p}(1,1):contSet2{p}(end,1),p)=contSet2{p}(:,2);   %pitch value
    salience(contSet2{p}(1,1):contSet2{p}(end,1),p)=contTs(p);
end