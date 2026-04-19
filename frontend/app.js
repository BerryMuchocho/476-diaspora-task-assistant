const BASE_URL = "http://127.0.0.1:8000/api";


// ----------------------
// CREATE TASK
// ----------------------
function createTask() {
    const message = document.getElementById("message").value;

    if (!message) {
        alert("Please enter a message");
        return;
    }

    fetch(`${BASE_URL}/process_request/`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ message })
    })
    .then(res => res.json())
    .then(data => {
        if (data.task_code) {
            document.getElementById("response").innerText =
                "Task Created: " + data.task_code;
        } else {
            document.getElementById("response").innerText =
                "Error: " + data.error;
        }

        loadTasks();
    })
    .catch(err => {
        console.error(err);
        alert("Request failed");
    });
}


// ----------------------
// LOAD TASKS
// ----------------------
function loadTasks() {
    fetch(`${BASE_URL}/tasks/`)
    .then(res => res.json())
    .then(data => {
        let html = "";

        data.forEach(task => {
            html += `
                <div class="task">
                    <b>${task.task_code}</b><br>
                    Intent: ${task.intent}<br>
                    Risk: ${task.risk_score}<br>
                    Status: ${task.status}<br>
                    Team: ${task.assigned_team}<br>

                    <button onclick="updateStatus('${task.task_code}', 'Pending')">Pending</button>
                    <button onclick="updateStatus('${task.task_code}', 'In Progress')">In Progress</button>
                    <button onclick="updateStatus('${task.task_code}', 'Completed')">Completed</button>
                </div>
            `;
        });

        document.getElementById("tasks").innerHTML = html;
    })
    .catch(err => {
        console.error(err);
    });
}


// ----------------------
// UPDATE STATUS (PUT)
// ----------------------
function updateStatus(taskCode, status) {
    fetch(`${BASE_URL}/task/${taskCode}/update/`, {
        method: "PUT",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ status })
    })
    .then(res => res.json())
    .then(data => {
        if (data.error) {
            alert(data.error);
        } else {
            alert("Updated: " + data.status);
        }

        loadTasks();
    })
    .catch(err => {
        console.error(err);
        alert("Update failed");
    });
}


// Auto-load on page start
loadTasks();
