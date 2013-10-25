function result = estimateSecondRawMoment(basis, i, j)
  result = integral(@(Y) ...
    basis.evaluate(Y(:), i, j, ones(size(Y)).').'.^2, ...
    basis.support(1), basis.support(2));
end