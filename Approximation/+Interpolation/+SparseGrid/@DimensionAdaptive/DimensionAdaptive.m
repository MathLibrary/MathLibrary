classdef DimensionAdaptive < Interpolation.SparseGrid.Base
  properties (SetAccess = 'private')
    basis
    adaptivityDegree
  end

  methods
    function this = DimensionAdaptive(varargin)
      options = Options(varargin{:});
      this = this@Interpolation.SparseGrid.Base(options);

      this.basis = Basis.Hat.DimensionWise('maximalLevel', this.maximalLevel);
      this.adaptivityDegree = options.get('adaptivityDegree', 0.9);
    end

    function values = evaluate(this, output, nodes, varargin)
      values = this.basis.evaluate(output.levels, output.orders, ...
        nodes, output.surpluses);
    end
  end
end