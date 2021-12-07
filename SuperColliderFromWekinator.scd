(
//1. server config
s = Server.local; //make sure s is reserved for Server
s.options.outDevice_( //have all your outputs listed just in case you want to change it later. have the main output in "" and the rest as comment
	"Built-in Output"
	//"Soundflower (2ch)"
	// "MOTU UltraLite mk3"

);
s.options.numOutputBusChannels_(2); //set number of output channels
s.options.inDevice_("Built-in Microph");
s.options.numInputBusChannels_(0);
// s.options.sampleRate_(48000); //make sure sample rate matches your audio bufs
s.options.memSize_(2.pow(20)); //increase memory size for safety (2 to the power of 20 will be around 1gb)
s.newBusAllocators;
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;

//2. initialize global variables
~out = 0; //to avoid having to change output number if your new device has it on a different bus. now you can only use ~out for outputs
~path = PathName(thisProcess.nowExecutingPath).parentPath++"buffers/"; //with this method you will avoid having to type your folder address, and the folder is directly linked to wherever you have saved your source code (template.scd)

// load all your mono audio samples

~makeBuffers = { //add the sub folders, and the sound files inside to your buffers
	b = Dictionary.new;
	PathName(~path).entries.do{
		arg subfolder;
		b.add(
			subfolder.folderName.asSymbol ->
			Array.fill(
				subfolder.entries.size,
				{
					arg i;
					Buffer.read(s, subfolder.entries[i].fullPath);
				}
			)
		);
	};
};

ServerBoot.add(~makeBuffers);

// 3. start OSCdef to receive OSC messages from Wekinator

OSCdef.new(\wekinator, {
	arg msg, time, addr, port;
	var list;
	msg[1];
	list = Array.fill(10, {msg[1]});
	~wekGest = list.mostCommonItem;
	list.clear;
}, "/wek/outputs", nil, 57120);

s.waitForBoot({ // boot your server

	s.sync;
	// add the audio playback synth to server

	(
		SynthDef(\bufplayer, {
			arg buf=0, spos=0, ttrig=0, amp=1, rev=0.33,
			out=0, rate=1, pan=0, ggate=0, loop=0;
			var sig, env;
			env = EnvGen.kr(Env([1,0,0],[0.01,BufDur.kr(buf) * 2]),ggate,doneAction:2);
			sig = PlayBuf.ar(1, buf, rate, ttrig, startPos:spos, loop:loop);
			sig = Pan2.ar(sig, LFNoise2.kr(rrand(0.8,1.5)).range(-1.5, 1.5));
			sig = sig * env;
			sig = FreeVerb.ar(sig, rev);
			sig = Pan2.ar(sig, pan, amp);
			Out.ar(out, sig);
		}).add;

	);

	1.yield;

	// Synth(\bufplayer).set(\buf, 0); //uncomment this to test your synth

	// define the properties of your gestures (buf number etc.)

	{
		~gesture1 = Routine({var buf1; buf1= b[\voice1][rrand(0, (b[\voice1].size - 1))];
			~voice1= Synth(\bufplayer).set(\buf, buf1.bufnum, \ttrig, 1, \spos, buf1.numFrames * [0,rrand(0.0,0.5)].wchoose([0.7,0.3]), \rev, rrand(0.11,0.88)); ~voice1.set(\ttrig,0);~voice2.set(\ggate,1);~voice3.set(\ggate,1);~voice4.set(\ggate,1)});
		~gesture2 = Routine({var buf2; buf2= b[\voice2][rrand(0, (b[\voice2].size - 1))];
			~voice2= Synth(\bufplayer).set(\buf, buf2.bufnum, \ttrig, 1, \rev, rrand(0.11,0.88)); ~voice2.set(\ttrig,0);~voice1.set(\ggate,1); ~voice3.set(\ggate,1); ~voice4.set(\ggate,1)});
		~gesture3 = Routine({var buf3; buf3= b[\voice3][rrand(0, (b[\voice3].size - 1))];
			~voice3= Synth(\bufplayer).set(\buf, buf3.bufnum, \ttrig, 1, \spos, buf3.numFrames * rrand(0.0,0.5), \rev, rrand(0.11,0.88)); ~voice3.set(\ttrig,0);~voice1.set(\ggate,1); ~voice2.set(\ggate,1); ~voice4.set(\ggate,1)});
		~gesture4 = Routine({var buf4; buf4= b[\voice4][rrand(0, (b[\voice4].size - 1))];
			~voice4= Synth(\bufplayer).set(\buf, buf4.bufnum, \ttring, 1, \spos, buf4.numFrames * rrand(0.0,0.5), \loop, 1, \rev, rrand(0.11,0.88)); ~voice4.set(\ttrig,0); ~voice1.set(\ggate,1); ~voice2.set(\ggate,1); ~voice3.set(\ggate,1)});

	}.value;


	// define the following two routines to start and stop your sound (gesture 5 stops the sound in this example)

	// these are the conditions used to control your 4 voices
	~synthRoutine = Routine( {
		loop{
			case { ~wekGest == 1 } { ~gesture1.play; ~gesture2.stop; ~gesture2.reset; ~gesture3.stop; ~gesture3.reset; ~gesture4.stop; ~gesture4.reset;}
			{ ~wekGest == 2 } { ~gesture2.play; ~gesture1.stop; ~gesture1.reset; ~gesture3.stop; ~gesture3.reset; ~gesture4.stop; ~gesture4.reset;}
			{ ~wekGest == 3 } { ~gesture3.play; ~gesture1.stop; ~gesture1.reset; ~gesture2.stop; ~gesture2.reset; ~gesture4.stop; ~gesture4.reset;}
			{ ~wekGest == 4 } { ~gesture4.play; ~gesture1.stop; ~gesture1.reset; ~gesture2.stop; ~gesture2.reset; ~gesture3.stop; ~gesture3.reset;}
			{ ~wekGest == 5 } { ~gesture1.stop; ~gesture1.reset; ~gesture2.stop; ~gesture2.reset; ~gesture3.stop; ~gesture3.reset; ~gesture4.stop; ~gesture4.reset;};
			0.1.wait;
		};
	}
	);

	1.yield;

	// Start making sounds!
	~synthRoutine.play;
});

);
