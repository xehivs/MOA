#!/usr/bin/env ruby
# Skrypt
require 'colorize'

classifiersSet = [ "moa.classifiers.functions.Perceptron", "moa.classifiers.bayes.NaiveBayes", "moa.classifiers.lazy.kNN" ]
generatorsSet = [ "generators.WaveformGeneratorDrift", "generators.RandomTreeGenerator", "generators.LEDGeneratorDrift" ]
chunksSet = [ 100, 1000, 10000, 100000 ]
chunkSizeSet = [ 10, 100, 1000 ]
thresholdSet = [ 0.25, 0.5, 0.75 ]
budgetSet = [ 0.125, 0.25, 0.5, 0.75 ]

experimentsCount = generatorsSet.length * classifiersSet.length * chunksSet.length * chunkSizeSet.length * thresholdSet.length * budgetSet.length
experimentNumber = 0

#system("rm results/*")

for chunks in chunksSet
for chunkSize in chunkSizeSet
for threshold in thresholdSet
for classifier in classifiersSet
for generator in generatorsSet
for budget in budgetSet
	experimentNumber += 1
    if experimentNumber < 1273 || experimentNumber > 1280
        next
    end
	classifierName = classifier.split('.').last.downcase
	generatorName = generator.split('.').last.downcase
	outputFilename = "#{classifierName}_#{generatorName}_i_#{chunks}_s_#{chunkSize}_t_#{threshold}_b_#{budget}.csv"
	command = "java -cp moa.jar -javaagent:sizeofag.jar moa.DoTask \"EvaluatePrequentialActive -l #{classifier} -s #{generator} -i #{chunks} -b #{budget} -r #{threshold} -c #{chunkSize} -t 300\" > results/#{outputFilename}"
	puts "# [#{experimentNumber}/#{experimentsCount}][#{(100*experimentNumber/experimentsCount).round}%]".red
	puts "# Testing #{classifierName} on #{generatorName}".yellow
	puts "# #{chunks} chunks #{chunkSize} instances each, on #{threshold} threshold and #{budget} budget".green
	system(command)
end
end
end
end
end
end

#java -cp moa.jar -javaagent:sizeofag.jar moa.DoTask "EvaluatePrequentialActive -l moa.classifiers.functions.Perceptron -s generators.WaveformGeneratorDrift -i 1000 -b 0.101 -r 0.751 -c 1000" > res.csv
