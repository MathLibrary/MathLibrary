function assessDynamicSteadyState(varargin)
  compare( ...
    Options(varargin{:}, 'analysis', 'DynamicSteadyState'), ...
    Options('algorithmVersion', 3));
end
