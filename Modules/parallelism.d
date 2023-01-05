module Modules.parallel;

import std.stdio, std.parallelism;
import Object.datatype, Object.strings, Object.boolean, Object.numbers;


// Parallel Module object
class Parallel: DataType {
	DataType[string] attributes;

	this(){
		this.attributes = [
			"Task": new NewTask(),
			"TaskQueue": new TaskQueue(),
			"cpu_cores": new Number(totalCPUs),
		];
	}
	
	override DataType[string] attrs() { return this.attributes; }

	override string __str__() { return "parallel (builtin module)";}
}


// Creates a new task object
class NewTask: DataType{
	override DataType __call__(DataType[] params){
		return new Tasker(params);
	}

	override string __str__() {return "Task (parallel object)"; }
}


// D function wrapper for maje function to use in the task
DataType fn(DataType[] fd){
	return fd[0].__call__(fd[1].__array__);
}


// New task and API to work with it.
class Tasker: DataType{
	DataType[string] attributes;

	this(DataType[] arg) {
		// creates task pointer in memory
		auto work = task!fn(arg);

		// executes task in a new thread
		class TaskRun: DataType{
			override DataType __call__(DataType[] params){ work.executeInNewThread(); return new None();}
			override string __str__() {return "run (Task method)";}
		}

		// work, spin, yield
		// If the Task isn't started yet, execute it in the current thread.
		// If its done return its return value or result.
		// If it threw an exception, rethrow that exception.


		// if any. If it's in progress, wait on a condition variable.
		// If it threw an exception, rethrow that exception.
		class TaskYield: DataType{
			override DataType __call__(DataType[] params){ return work.yieldForce();}
			override string __str__() {return "yield (Task method)";}
		}

		// If it is in progress, execute any other Task from the TaskPool instance that this Task 
		// was submitted to until this one is finished.
		// If no other tasks are available or this Task was executed using executeInNewThread/run,
		// wait on a condition variable.
		class TaskWork: DataType{
			override DataType __call__(DataType[] params){ return work.workForce();}
			override string __str__() {return "work (Task method)";}
		}

		//  If it's in progress, busy spin until it's done, then return the return value. 
		class TaskSpin: DataType{
			override DataType __call__(DataType[] params){ return work.spinForce();}
			override string __str__() {return "spin (Task method)";}
		}

		// waits for the task to finish before Parent thread terminates.
		class TaskWait: DataType{
			override DataType __call__(DataType[] params){
				while (!work.done()){ }
				return work.yieldForce();
			}
			override string __str__() {return "spin (Task method)";}
		}

		// Returns true if the Task is finished executing.
		class TaskDone: DataType{
			override DataType __call__(DataType[] params){
				if (work.done)
					return new True();
				return new False();
			}

			override string __str__() {return "isdone (Task method)";}
		}

		this.attributes = [
			"run": new TaskRun(),
			"wait": new TaskWait(),
			"isdone": new TaskDone(),
			"work": new TaskWork(),
			"spin": new TaskSpin(),
			"yield": new TaskYield(),
		];
	}

	override DataType[string] attrs() {return this.attributes; }
	override string __str__() { return "Task (parallel object)"; }
}


// Object to deal with taskPool API
class TaskQueue: DataType{
	DataType[string] attributes;

	this() {
		this.attributes = [
			"put": new tQueuePut(),
			"windUp": new tQueueWindup(),
			"stopAll": new tQueueStop(),
		];
	}

	override DataType[string] attrs() {return this.attributes; }
	override string __str__() { return "TaskQueue (parallel task)"; }
}


// Put a Task object on the back of the task queue.
class tQueuePut: DataType{
	override DataType __call__(DataType[] params){
		auto work = task!fn(params);
		taskPool.put(work);
		return new None();
	}

	override string __str__() {return "put (Task method)";}
}


//	Signals to all worker threads to terminate as soon as they are finished with their current Task, or immediately if they are
//  not executing a Task. Tasks that were in queue will not be executed unless a call to Task.workForce, Task.yieldForce or 
//  Task.spinForce causes them to be executed.
class tQueueStop: DataType{
	override DataType __call__(DataType[] params){
		taskPool.stop();
		return new None();
	}

	override string __str__() {return "stopAll (Task method)";}
}


// Signals worker threads to terminate when the queue becomes empty.
class tQueueWindup: DataType{
	override DataType __call__(DataType[] params){
		taskPool.finish();
		return new None();
	}

	override string __str__() {return "windUp (Task method)";}
}


