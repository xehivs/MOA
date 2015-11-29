/*
 *    EvaluatePrequentialActive.java
 *    Copyright (C) 2007 University of Waikato, Hamilton, New Zealand
 *    @author Richard Kirkby (rkirkby@cs.waikato.ac.nz)
 *    @author Albert Bifet (abifet at cs dot waikato dot ac dot nz)
 *
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program. If not, see <http://www.gnu.org/licenses/>.
 *    
 */
package moa.tasks;

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;

import java.util.ArrayList;
import java.util.Collections;

import moa.classifiers.Classifier;
import moa.core.Example;
import moa.core.Measurement;
import moa.core.ObjectRepository;
import moa.core.TimingUtils;
import moa.evaluation.WindowClassificationPerformanceEvaluator;
import moa.evaluation.EWMAClassificationPerformanceEvaluator;
import moa.evaluation.FadingFactorClassificationPerformanceEvaluator;
import moa.evaluation.LearningCurve;
import moa.evaluation.LearningEvaluation;
import moa.evaluation.LearningPerformanceEvaluator;
import moa.learners.Learner;
import moa.options.ClassOption;

import com.github.javacliparser.FileOption;
import com.github.javacliparser.FloatOption;
import com.github.javacliparser.IntOption;
import moa.streams.ExampleStream;
import moa.streams.InstanceStream;
import com.yahoo.labs.samoa.instances.Instance;
import moa.core.Utils;

/**
 * Task for evaluating a classifier on a stream by testing then training with each example in sequence.
 *
 * @author Richard Kirkby (rkirkby@cs.waikato.ac.nz)
 * @author Albert Bifet (abifet at cs dot waikato dot ac dot nz)
 * @version $Revision: 7 $
 */
public class EvaluatePrequentialActive extends MainTask 
{
    @Override
    public String getPurposeString() {
        return "Evaluates a classifier on a stream by testing then training with each example in sequence.";
    }

    private static final long serialVersionUID = 1L;

    public ClassOption learnerOption = new ClassOption("learner", 'l',
        "Learner to train.", Learner.class, "moa.classifiers.bayes.NaiveBayes");

    public ClassOption streamOption = new ClassOption("stream", 's',
        "Stream to learn from.", ExampleStream.class,
        "generators.RandomTreeGenerator");

    public ClassOption evaluatorOption = new ClassOption("evaluator", 'e',
        "Classification performance evaluation method.",
        LearningPerformanceEvaluator.class,
        "WindowClassificationPerformanceEvaluator");

    public IntOption chunkLimitOption = new IntOption("chunkLimit", 'i',
        "Maximum number of chunks to test/train on  (-1 = no limit).",
        1000000, -1, Integer.MAX_VALUE);

    public FloatOption budgetOption = new FloatOption("budget", 'b',
        "Budget.", .1, 0, 1);

    public FloatOption thresholdOption = new FloatOption("threshold", 'r',
        "Treshold.", .75, 0, 1);

    public IntOption chunkSizeOption = new IntOption(
        "chunkSize", 'c',
        "How many instances in chunk.", 1000, 0,
        Integer.MAX_VALUE);

    public IntOption timeLimitOption = new IntOption("timeLimit", 't',
        "Maximum number of seconds to test/train for (-1 = no limit).", -1,
        -1, Integer.MAX_VALUE);

    public IntOption chunkFrequencyOption = new IntOption("chunkFrequency",
        'f',
        "How many chunks between samples of the learning performance.",
        10, 0, Integer.MAX_VALUE);

    public IntOption memCheckFrequencyOption = new IntOption(
        "memCheckFrequency", 'q',
        "How many chunks between memory bound checks.", 100000, 0,
        Integer.MAX_VALUE);

    public FileOption dumpFileOption = new FileOption("dumpFile", 'd',
        "File to append intermediate csv results to.", null, "csv", true);

    public FileOption outputPredictionFileOption = new FileOption("outputPredictionFile", 'o',
        "File to append output predictions to.", null, "pred", true);

    //New for prequential method DEPRECATED
    public IntOption widthOption = new IntOption("width",
        'w', "Size of Window", 1000);

    public FloatOption alphaOption = new FloatOption("alpha",
        'a', "Fading factor or exponential smoothing factor", .01);
    //End New for prequential methods

    @Override
    public Class<?> getTaskResultType() {
        return LearningCurve.class;
    }

    @Override
    protected Object doMainTask(TaskMonitor monitor, ObjectRepository repository) 
    {

        // Przypisujemy klasyfikator, generator strumienia i ewaluator
        Learner learner = (Learner) getPreparedClassOption(this.learnerOption);
        ExampleStream stream = (ExampleStream) getPreparedClassOption(this.streamOption);
        learner.setModelContext(stream.getHeader());
        LearningPerformanceEvaluator evaluator = (LearningPerformanceEvaluator) getPreparedClassOption(this.evaluatorOption);

        // Przypisanie krzywej uczącej
        LearningCurve learningCurve = new LearningCurve(
            "learning evaluation instances");

        // Określanie parametrów
        int maxChunks = this.chunkLimitOption.getValue();
        int maxSeconds = this.timeLimitOption.getValue();
        int chunkSize = this.chunkSizeOption.getValue();
        int budget = (int) (chunkSize * this.budgetOption.getValue());
        double threshold = this.thresholdOption.getValue() * 100;
        
        long chunksProcessed = 0;
        int secondsElapsed = 0;
        
        File dumpFile = this.dumpFileOption.getFile();
        PrintStream immediateResultStream = null;
        if (dumpFile != null) {
            try {
                if (dumpFile.exists()) {
                    immediateResultStream = new PrintStream(
                        new FileOutputStream(dumpFile, true), true);
                } else {
                    immediateResultStream = new PrintStream(
                        new FileOutputStream(dumpFile), true);
                }
            } catch (Exception ex) {
                throw new RuntimeException(
                    "Unable to open immediate result file: " + dumpFile, ex);
            }
        }

        //File for output predictions
        File outputPredictionFile = this.outputPredictionFileOption.getFile();
        PrintStream outputPredictionResultStream = null;
        if (outputPredictionFile != null) {
            try {
                if (outputPredictionFile.exists()) {
                    outputPredictionResultStream = new PrintStream(
                        new FileOutputStream(outputPredictionFile, true), true);
                } else {
                    outputPredictionResultStream = new PrintStream(
                        new FileOutputStream(outputPredictionFile), true);
                }
            } catch (Exception ex) {
                throw new RuntimeException(
                    "Unable to open prediction result file: " + outputPredictionFile, ex);
            }
        }
        boolean firstDump = true;
        boolean preciseCPUTiming = TimingUtils.enablePreciseTiming();
        long evaluateStartTime = TimingUtils.getNanoCPUTimeOfCurrentThread();
        long lastEvaluateStartTime = evaluateStartTime;
        double RAMHours = 0.0;


        // Tu startujemy
        monitor.setCurrentActivity("Processing...", -1.0);
    
        while (stream.hasMoreInstances()
            && ((maxChunks < 0) || (chunksProcessed < maxChunks))
            && ((maxSeconds < 0) || (secondsElapsed < maxSeconds))) {

            ArrayList instances = new ArrayList();      // collect data in data chunk
            for(int i = 0 ; i < chunkSize ; i++)
                instances.add(stream.nextInstance());

            Collections.shuffle(instances);             // randomize chunk
            int budgetSpent = 0;                        // reset budget
            
            for (int i = 0; i < instances.size(); i++)  // for each instance in chunk
            {
                Example instance = (Example) instances.get(i);
                double[] prediction = learner.getVotesForInstance(instance);
                evaluator.addResult(instance, prediction);
                
                double support = ( (Measurement) evaluator.getPerformanceMeasurements()[1]).getValue();
                if (budgetSpent < budget && support < threshold) 
                {
                    learner.trainOnInstance(instance);
                    budgetSpent ++;
                }

                // Output prediction
                if (outputPredictionFile != null) 
                {
                    int trueClass = (int) ((Instance) instance.getData()).classValue();
                    outputPredictionResultStream.println(Utils.maxIndex(prediction) + "," + trueClass);
                }
            }

            chunksProcessed ++;

            if (chunksProcessed % this.chunkFrequencyOption.getValue() == 0
                || stream.hasMoreInstances() == false) 
            {
                long evaluateTime = TimingUtils.getNanoCPUTimeOfCurrentThread();
                double time = TimingUtils.nanoTimeToSeconds(evaluateTime - evaluateStartTime);
                double timeIncrement = TimingUtils.nanoTimeToSeconds(evaluateTime - lastEvaluateStartTime);
                double RAMHoursIncrement = learner.measureByteSize() / (1024.0 * 1024.0 * 1024.0); //GBs
                RAMHoursIncrement *= (timeIncrement / 3600.0); //Hours
                RAMHours += RAMHoursIncrement;
                lastEvaluateStartTime = evaluateTime;
                learningCurve.insertEntry(new LearningEvaluation(
                    new Measurement[]{
                        new Measurement(
                            "learning evaluation instances",
                            chunksProcessed),
                        new Measurement(
                            "evaluation time ("
                                + (preciseCPUTiming ? "cpu "
                                    : "") + "seconds)",
                        time),
                        new Measurement(
                            "model cost (RAM-Hours)",
                            RAMHours)
                    },
                    evaluator, learner));

                if (immediateResultStream != null) {
                    if (firstDump) {
                        immediateResultStream.println(learningCurve.headerToString());
                        firstDump = false;
                    }
                    immediateResultStream.println(learningCurve.entryToString(learningCurve.numEntries() - 1));
                    immediateResultStream.flush();
                }
            }
            if (chunksProcessed % INSTANCES_BETWEEN_MONITOR_UPDATES == 0) {
                if (monitor.taskShouldAbort()) {
                    return null;
                }
                long estimatedRemainingInstances = stream.estimatedRemainingInstances();
                if (maxChunks > 0) {
                    long maxRemaining = maxChunks - chunksProcessed;
                    if ((estimatedRemainingInstances < 0)
                        || (maxRemaining < estimatedRemainingInstances)) {
                        estimatedRemainingInstances = maxRemaining;
                }
            }
            monitor.setCurrentActivityFractionComplete(estimatedRemainingInstances < 0 ? -1.0
                : (double) chunksProcessed
                / (double) (chunksProcessed + estimatedRemainingInstances));
            if (monitor.resultPreviewRequested()) {
                monitor.setLatestResultPreview(learningCurve.copy());
            }
            secondsElapsed = (int) TimingUtils.nanoTimeToSeconds(TimingUtils.getNanoCPUTimeOfCurrentThread()
                - evaluateStartTime);
        }
    }
    if (immediateResultStream != null) {
        immediateResultStream.close();
    }
    if (outputPredictionResultStream != null) {
        outputPredictionResultStream.close();
    }
    return learningCurve;
}
}
