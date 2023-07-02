# Multi-User ToDo List in Erlang

## Overview

As a part of my continuous journey in learning functional programming and distributed systems, I developed a simple Multi-User ToDo List project in Erlang. This project is aimed at enhancing my understanding of functional programming, concurrency, and actor model concepts that Erlang provides out of the box.

The Multi-User ToDo List is an Erlang-based program that handles multiple users and their individual ToDo lists. Each user can add, mark as done, remove, and list their tasks. Each task has properties such as description, status, priority, and deadline.

This project was developed with the objective of learning and practicing Erlang's functional programming features, its process-based concurrency model, and message passing mechanisms to manage multiple users' state. Additionally, this project helped me understand the importance of immutable data structures in concurrent programming.

## Development Environment

The project was developed using the Visual Studio Code IDE, with the Erlang/OTP platform. Erlang was used as the primary language for the entire development. The built-in lists module was used extensively for list manipulation tasks.

The application was developed and tested on a local machine. To extend this into a distributed environment, the built-in features of Erlang/OTP such as distributed Erlang, nodes, and OTP behaviours can be used.

## Useful Websites

Here are a few resources that proved to be invaluable during the development of this project:

- [Erlang Documentation](https://erlang.org/doc/)
- [Learn You Some Erlang for Great Good!](https://learnyousomeerlang.com/)
- [Stack Overflow](https://stackoverflow.com/)

## Future Work

The current implementation is fairly simple and there are numerous avenues for future improvements:

- Implement a database (like Mnesia or an external DB) to persist the users and their tasks.
- Introduce a proper authentication and authorization system for the users.
- Develop a GUI or a web interface for users to interact with their ToDo lists.
- Add more features such as sharing tasks between users, setting reminders, adding notes to tasks, etc.
- Utilize the features of Erlang/OTP to make this a distributed application.
- Add testing using EUnit or Common Test.
