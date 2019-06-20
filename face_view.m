function face_view(face)

if face == 1
    set(gca,'CameraPosition',[1000 0 0]);
elseif face == 2
    set(gca,'CameraPosition',[0 1000 0]);
elseif face == 3
    set(gca,'CameraPosition',[0 0 1000]);
elseif face == 4
    set(gca,'CameraPosition',[-1000 0 0]);
elseif face == 5
    set(gca,'CameraPosition',[0 -1000 0]);
elseif face == 6
    set(gca,'CameraPosition',[0 0 -1000]);
end

end