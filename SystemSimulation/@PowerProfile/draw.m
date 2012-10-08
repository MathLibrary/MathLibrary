function draw(this)
  figure;

  [ stepCount, processorCount ] = size(this.values);

  time = this.samplingInterval * ((1:stepCount) - 1);

  labels = cell(1, processorCount);

  for i = 1:processorCount
    line(time, this.values(:, i), 'Color', Color.pick(i));
    labels{i} = sprintf('PE %d', i);
  end

  xlabel('Time, s', 'FontSize', 14);
  ylabel('Dynamic power, W', 'FontSize', 14);
  xlim([ 0, time(end) ]);
  legend(labels{:});
end