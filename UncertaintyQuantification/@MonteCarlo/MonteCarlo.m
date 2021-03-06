classdef MonteCarlo < handle
  properties (SetAccess = 'protected')
    inputCount
    sampleCount
    distribution
  end

  methods
    function this = MonteCarlo(varargin)
      options = Options(varargin{:});
      this.inputCount = options.get('inputCount', 1);
      this.sampleCount = options.get('sampleCount', 1e3);
      this.distribution = options.get( ...
        'distribution', ProbabilityDistribution.Gaussian);
    end

    function output = construct(this, target)
      output.nodes = this.distribution.sample( ...
        this.sampleCount, this.inputCount);
      output.data = target(output.nodes);
      output.target = target;
    end

    function data = evaluate(this, output, nodes, isUniform)
      if nargin > 3 && isUniform
        nodes = this.distribution.icdf(nodes);
      end
      data = output.target(nodes);
    end

    function stats = analyze(~, output)
      stats.expectation = mean(output.data, 1);
      stats.variance = var(output.data, [], 1);
    end

    function display(this, varargin)
      display(Options(this), class(this));
    end

    function string = toString(this, varargin)
      string = Options(this).toString(varargin{:});
    end
  end
end
