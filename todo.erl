-module(todo).

%% Use Erlang record to structure our task
-record(task, {id, description, status = todo, priority = normal, deadline}).

%% Use Erlang record to structure our user
-record(user, {username, password, todo_list = new()}).

%% Exported functions
-export([new/0, add_user/3, delete_user/2, add_task/5, validate_task/1, mark_done/3, remove_task/3, list_tasks/2, list_by_status/3, count_by_status/3, overdue_tasks/2, sort_by_priority/2, start_notification/2, stop_notification/0]).

%% Store the notification process' PID
-define(NOTIFICATION_PID, notification_pid).

%% User database
-define(USER_DB, []).

%% Function to create a new empty TODO list
new() -> [].

%% Function to add a new user
add_user(Username, Password, UserDB) when is_list(UserDB) ->
    User = #user{username = Username, password = Password},
    [User | UserDB].

%% Function to delete a user
delete_user(Username, UserDB) when is_list(UserDB) ->
    lists:filter(fun(#user{username = U}) -> U /= Username end, UserDB).

%% Function to add a new task to a user's list
add_task(Task = #task{}, Deadline, Priority, Username, UserDB) when is_list(UserDB) ->
    %% Validate the task before adding
    case validate_task(Task) of
        ok -> 
            lists:map(fun(User = #user{username = U, todo_list = List}) ->
                if U == Username -> User#user{todo_list = add(Task#task{deadline = Deadline, priority = Priority}, List)};
                    true -> User end
            end, UserDB);
        {error, _} = Error -> Error
    end.

%% Function to validate a task
validate_task(Task = #task{}) ->
    case Task#task.description of
        Desc when is_binary(Desc) andalso byte_size(Desc) > 0 -> ok;
        _ -> {error, invalid_description}
    end;
validate_task(_) -> 
    {error, invalid_task}.

%% Function to mark a task as done
mark_done(TaskId, Username, UserDB) when is_list(UserDB) ->
    lists:map(fun(User = #user{username = U, todo_list = List}) ->
        if U == Username -> User#user{todo_list = mark_done(TaskId, List)};
            true -> User end
    end, UserDB).

%% Function to remove a task from a user's list
remove_task(TaskId, Username, UserDB) when is_list(UserDB) ->
    lists:map(fun(User = #user{username = U, todo_list = List}) ->
        if U == Username -> User#user{todo_list = remove(TaskId, List)};
            true -> User end
    end, UserDB).

%% Function to list all tasks of a user
list_tasks(Username, UserDB) when is_list(UserDB) ->
    case lists:keyfind(Username, 1, UserDB) of
        {Username, _, List} -> List;
        _ -> undefined
    end.

%% Function to list tasks by status
list_by_status(Status, Username, UserDB) when is_list(UserDB) ->
    case lists:keyfind(Username, 1, UserDB) of
        {Username, _, List} -> list_by_status(Status, List);
        _ -> undefined
    end.

%% Function to count tasks by status
count_by_status(Status, Username, UserDB) when is_list(UserDB) ->
    case lists:keyfind(Username, 1, UserDB) of
        {Username, _, List} -> count_by_status(Status, List);
        _ -> undefined
    end.

%% Function to check overdue tasks
overdue_tasks(Username, UserDB) when is_list(UserDB) ->
    case lists:keyfind(Username, 1, UserDB) of
        {Username, _, List} -> overdue_tasks(List);
        _ -> undefined
    end.

%% Function to sort tasks by priority
sort_by_priority(Username, UserDB) when is_list(UserDB) ->
    case lists:keyfind(Username, 1, UserDB) of
        {Username, _, List} -> sort_by_priority(List);
        _ -> undefined
    end.

%% Function to start notification process for a user
start_notification(Username, UserDB) ->
    case whereis(?NOTIFICATION_PID) of
        undefined ->
            Pid = spawn(fun() -> notification_loop(Username, UserDB) end),
            register(?NOTIFICATION_PID, Pid);
        _ -> already_started
    end.

%% Function to stop notification process
stop_notification() ->
    case whereis(?NOTIFICATION_PID) of
        undefined -> already_stopped;
        Pid -> 
            Pid ! stop,
            ok
    end.

%% Loop that continuously checks for due tasks
notification_loop(Username, UserDB) ->
    receive
        stop -> ok
    after 5000 -> %% Check every 5 seconds
        case overdue_tasks(Username, UserDB) of
            [] -> ok;
            OverdueTasks -> io:format("User ~s has the following tasks overdue: ~p~n", [Username, OverdueTasks])
        end,
        notification_loop(Username, UserDB)
    end.
