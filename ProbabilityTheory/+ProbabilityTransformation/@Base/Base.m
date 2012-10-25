classdef Base < handle
  properties (SetAccess = 'protected')
    dimension
    variables
    distribution
  end

  methods
    function this = Base(variables, varargin)
      options = Options(varargin{:});
      this.initialize(variables, options);
    end
  end

  methods (Abstract)
    data = sample(this, samples)
    data = evaluate(this, data)
  end

  methods (Access = 'protected')
    function initialize(this, variables, options)
      this.dimension = variables.dimension;
      this.variables = variables;
    end
  end
end
