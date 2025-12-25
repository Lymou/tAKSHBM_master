function A=tblur(N,sigma,band)
    z = [exp(-([0:band-1].^2)/(2*sigma^2)), zeros(1,N-band)];
    g=1/((sigma*2*pi)^.5);
    zz=[z(1)*fliplr(z(end-length(z)+2:end))];
    A1=g*toeplitz(z,zz);
    A2=g*toeplitz(z);
    for k=1:N
        A(:,:,k)=A1(k,1)*A2;
    end
end