function y = networkdeploy(number, size, range)

position = rand(number,2)*size - size/2; 
pcopy = posiion;

left = size(position,1);
paraentlayer = [];
childlayer = [];

while left ~= 0 
    for i = 1 : 1 : size(paraentlayer, 1)
        if postion(i,1)^2 + position(i,2)^2 <= range^2
            layer = [layer; position(i,:)];
            pcopy(i, :) = [];
        
        end
    end
end


end