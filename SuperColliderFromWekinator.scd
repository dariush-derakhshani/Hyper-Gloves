// Start OSCdef to receive OSC messages from Wekinator
// Run the server (CMD + B)

(
OSCdef.new(\wekinator, {
	arg msg, time, addr, port;
	var list;
	msg[1];
	list = Array.fill(10, {msg[1]});
	~wekGest = list.mostCommonItem;
	list.clear;
}, "/wek/outputs", nil, 57120);
);

// Add synth to server

(
SynthDef(\Sine, {
	arg freq=440;
	var sig, env;
	sig = Mix.fill(10,
		{
			sig = SinOsc.ar(freq + rrand(-100,100), rrand(0.0,1.0), LFNoise2.kr(rrand(1.0,10.0)).range(0.05,0.4))

	});
	env = EnvGen.kr(Env([0,1,0,0],[0.1,0.2,2]), doneAction:2);
	sig = sig * env;
	sig = Limiter.ar(sig, 0.99,0.01);
	sig = Pan2.ar(sig, LFNoise2.kr(rrand(0.1,1.0)).range(-1.0,1.0));
	sig = FreeVerb.ar(sig, 0.77);
	sig = Out.ar(0, sig);

}).add);

// Test your synth to make sure you're receving sound

Synth(\Sine).set(\freq, 440); //test your synth

// Define the following two routines to start and stop your sound (gesture 5 stops the sound in this example)

(
// These are the arguments being sent to your synth
~synthRoutine = Routine( {
	loop{
		case { ~wekGest == 1 } { Synth(\Sine).set(\freq, rrand(500,600)) }
		{ ~wekGest == 2 } { Synth(\Sine).set(\freq, rrand(300,400)) }
		{ ~wekGest == 3 } { Synth(\Sine).set(\freq, rrand(200,300)) }
		{ ~wekGest == 4 } { Synth(\Sine).set(\freq, rrand(100,200)) }
		{ ~wekGest == 5 } { ~mainRoutine.reset; 0.01.wait; ~mainRoutine.play};
		0.1.wait;
	};
}
);

// This is where you define how to start and stop the sound (~wekGest 5 stops the sound)
~mainRoutine = Routine( {
	loop{
		case
		{ ~wekGest == 5 } { ~synthRoutine.stop; 0.01.wait; ~synthRoutine.reset;}
		{ ~wekGest != 5 } { ~synthRoutine.play; ~mainRoutine.stop;};
		0.1.wait;
	}
});
);

// Run this command to start the sound. If you don't hear anything after running this command, make sure you're not performing 'Gesture 5'

~synthRoutine.play;