function theat = calJointAngle()

        theta = asin(-(rshoulder(3,:) - relbow(3,:)) ./ dist(rshoulder, relbow));
        theta =[theta; -asin((rshoulder(1,:) - relbow(1,:)) ./ dist(rshoulder, relbow))];
        theta =[theta; -asin((relbow(1,:) - rwrist(1,:)) ./ dist(relbow, rwrist))];
        
        theta =[theta; acos( ...
        (dist(rshoulder, rwrist).^2 - dist(rshoulder, relbow).^2 - dist(relbow,rwrist).^2)./ ...
        (2*dist(rshoulder,relbow).*dist(relbow,rwrist)) ...
        )];

        theta =[theta; asin(-(lshoulder(3,:) - lelbow(3,:)) ./ dist(lshoulder, lelbow))];
        theta =[theta; -asin((lshoulder(1,:) - lelbow(1,:)) ./ dist(lshoulder, lelbow))];
        theta =[theta; -asin((lelbow(1,:) - lwrist(1,:)) ./ dist(lelbow, lwrist))];
        theta =[theta; acos( ...
        (dist(lshoulder, lwrist).^2 - dist(lshoulder, lelbow).^2 - dist(lelbow,lwrist).^2)./ ...
        (2*dist(lshoulder,lelbow).*dist(lelbow,lwrist)) ...
        )];

        theta =[theta; asin((rhip(2,:) - rknee(2,:)) ./ dist(rhip, rknee))];
        theta =[theta; asin((rhip(1,:) - rknee(1,:)) ./ dist(rhip, rknee))];
        theta =[theta; asin((rknee(1,:) - rankle(1,:)) ./ dist(rknee, rankle))];

        theta =[theta; asin((lhip(2,:) - lknee(2,:)) ./ dist(lhip, lknee))];
        theta =[theta; asin((lhip(1,:) - lknee(1,:)) ./ dist(lhip, lknee))];
        theta =[theta; asin((lknee(1,:) - lankle(1,:)) ./ dist(lknee, lankle))];

        video(i).data = theta;
end