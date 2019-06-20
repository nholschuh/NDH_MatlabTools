if temp(3) == 99        %Build a centering function for the c key
    if temp(1)-xrange > xs(1)
        if temp(1) + xrange < xs(2)
            x1 = temp(1) - xrange;
            x2 = temp(1) + xrange;
        else
            x1 = xs(2) - xrange;
            x2 = xs(2);
        end
    else
        x1 = xs(1);
        x2 = xs(1) + xrange;
    end
    if temp(2)-yrange > ys(1)
        if temp(2) + yrange < ys(2)
            y1 = temp(2)-yrange;
            y2 = temp(2)+yrange;
        else
            y1 = ys(2) - 2*yrange;
            y2 = ys(2);
        end
    else
        y1 = ys(1);
        y2 = ys(1) + 2*yrange;
    end
        xlim([x1 x2])
        ylim([y1 y2])

    i = i-1;
end