# HEADER

### The log file headers
stimulus_properties = stimulus_time, string, response_time, string, reaction_time, string;
event_code_delimiter = ";";

### Set the number of active buttons in the scenario settings
active_buttons = 1;  ## Currently G is the active button
button_codes = 1;

### Some default parameters
response_matching = simple_matching;
response_logging = log_active; # Only log active responses
default_output_port = 1;


#SDL
begin;

### Creating the sound "Press" stimulus event element
sound {
	wavefile {filename = "temp.wav";};
}press_sound;

### Create the sound trial
trial {
	
	trial_duration = forever;
	trial_type = first_response;
	
	stimulus_event{
		sound press_sound;
		time = 0;
		target_button = 1;
		response_active = true;
	}press_stim_event;
}sound_trial;


# PCL
begin_pcl;

### Variables
int noRandom = 10; ## Will use 10 random numbers from the file
int no_press_calls = 5; ## The number of press calls
string file_path = "randomNumbers"; ## Path of the random numbers file

# Make an array of random numbers from given txt fileS
array <int> randomNumbers[noRandom];

input_file in = new input_file;
in.open("C:/presentationPrograms/press/randomNumbers.txt");

loop int i = 1;
until in.end_of_file() || !in.last_succeeded() || i > noRandom
begin
	randomNumbers[i] = in.get_int();
	i = i + 1;
end;

# Begin presenting the trials with random ISI
loop int i = 1;
until i > no_press_calls
begin
	sound_trial.present();
	
	## Get the most recent stimulus and response
	stimulus_data last_stimulus = stimulus_manager.last_stimulus_data();
	response_data last_response = response_manager.last_response_data();
	
	## Get the relative time for the most recent stimulus and response
	int last_stimulus_time = last_stimulus.time();
	int last_response_time = last_response.time();
	
	## Calculate the reaction time
	int reaction_time = last_response_time - last_stimulus_time;
	
	## Set the values in the log file
	last_stimulus.set_event_code(string(last_stimulus_time) + ";" + string(last_response_time) + ";" + string(reaction_time));
	
	## Wait for the random time interval
   wait_interval(randomNumbers[i]*1000);
	
	i = i + 1;
end;

