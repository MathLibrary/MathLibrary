function output = construct(this, Lgrid, Tgrid, Igrid, options)
  expression = options.expression;
  output.evaluate = Utils.constructCustomFit( ...
    [ Lgrid(:), Tgrid(:) ], Igrid(:), expression.F, ...
    [ expression.L, expression.T ], expression.C);
end