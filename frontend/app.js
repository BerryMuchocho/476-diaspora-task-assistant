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
            const entities = JSON.stringify(task.entities || {}, null, 2);
            const steps = (task.steps || []).map(step => `<li>${step}</li>`).join("");
            const history = (task.status_history || [])
                .map(item => `<li>${item.old_status || "Created"} → ${item.new_status} (${new Date(item.changed_at).toLocaleString()})</li>`)
                .join("");

            html += `
                <div class="task">
                    <b>${task.task_code}</b><br>
                    Intent: ${task.intent}<br>
                    Risk: ${task.risk_score}<br>
                    Status: ${task.status}<br>
                    Team: ${task.assigned_team}<br>
                    Created: ${new Date(task.created_at).toLocaleString()}<br>
                    <pre>Entities: ${entities}</pre>
                    <div><b>Steps</b><ol>${steps}</ol></div>
                    <div><b>WhatsApp</b><br>${task.messages?.whatsapp || ""}</div>
                    <div><b>Email</b><br>${task.messages?.email || ""}</div>
                    <div><b>SMS</b><br>${task.messages?.sms || ""}</div>
                    <div><b>Status History</b><ul>${history}</ul></div>

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
