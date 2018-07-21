function OVec = randomlySelectA1A2B1B2GivenInlierRate(N,NG)

    rand1 = round(rand()*(N-NG));
    rand2 = round(rand()*(N-NG-rand1));
    rand3 = round(rand()*(N-NG-rand1-rand2));
    rand4 = round(rand()*(N-NG-rand1-rand2-rand3));
    tempVec(randperm(4)) = [rand1 rand2 rand3 rand4];
    OVec = [(1+tempVec(1)) (N-tempVec(2)) (1+tempVec(3)) (N-tempVec(4))];

end