classdef ASGC < handle
  properties (SetAccess = 'protected')
    inputDimension
    outputDimension

    level
    nodeCount
    levelNodeCount

    nodes
    levelIndex

    surpluses

    expectation
    variance
    secondRawMoment
  end

  methods
    function this = ASGC(f, varargin)
      options = Options(varargin{:});
      this.construct(f, options);
    end

    function display(this)
      fprintf('Adaptive sparse grid collocation:\n');
      fprintf('  Input dimension:  %d\n', this.inputDimension);
      fprintf('  Output dimension: %d\n', this.outputDimension);
      fprintf('  Level:            %d\n', this.level);
      fprintf('  Nodes:            %d\n', this.nodeCount);
      fprintf('  Last nodes:       %d\n', this.levelNodeCount(end));
    end
  end

  methods (Access = 'protected')
    construct(this, f, options)
  end
end
