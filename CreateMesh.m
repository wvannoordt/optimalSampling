function [meshout] = CreateMesh(settings)
    meshout.xNode = linspace(settings.bounds(1), settings.bounds(2), settings.Nmesh(1)+1);
    meshout.yNode = linspace(settings.bounds(3), settings.bounds(4), settings.Nmesh(2)+1);
    meshout.xCell = 0.5*(meshout.xNode(1:end-1) + meshout.xNode(2:end));
    meshout.yCell = 0.5*(meshout.yNode(1:end-1) + meshout.yNode(2:end));
end