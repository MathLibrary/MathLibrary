function display(this)
  options = Options( ...
    'Input dimension', this.inputCount, ...
    'Output dimension', this.outputCount, ...
    'Order', this.order, ...
    'Nodes', this.nodeCount, ...
    'Interpolants', length(this.interpolants));
  display(options, 'High-dimensional model representation');
end
