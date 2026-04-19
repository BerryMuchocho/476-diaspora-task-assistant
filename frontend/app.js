const BASE_URL = "http://127.0.0.1:8000/api";
let allTasks = [];

function escapeHtml(value) {
    return String(value)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#39;");
}

function statusClass(status) {
    if (status === "Completed") return "status-completed";
    if (status === "In Progress") return "status-in-progress";
    return "status-pending";
}

function fillExample(message) {
    document.getElementById("message").value = message;
}

function showView(view) {
    const customerView = document.getElementById("customer-view");
    const adminView = document.getElementById("admin-view");
    const customerTab = document.getElementById("customer-tab");
    const adminTab = document.getElementById("admin-tab");

    if (view === "admin") {
        customerView.classList.add("hidden-view");
        adminView.classList.remove("hidden-view");
        customerTab.classList.remove("active-tab");
        adminTab.classList.add("active-tab");
    } else {
        adminView.classList.add("hidden-view");
        customerView.classList.remove("hidden-view");
        adminTab.classList.add("active-tab");
        customerTab.classList.remove("active-tab");
    }
}

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
    .then(async (res) => {
        let data;

        // SAFELY PARSE JSON (prevents false "Request failed")
        try {
            data = await res.json();
        } catch (err) {
            console.error("JSON parse error:", err);
            document.getElementById("response").innerText =
                "Server returned invalid response";
            return;
        }

        // DEBUG (keep this for now)
        console.log("BACKEND RESPONSE:", data);

        // HANDLE BACKEND ERRORS PROPERLY
        if (!res.ok) {
            document.getElementById("response").innerText =
                `Error: ${data.error || "Request failed"}`;
            return;
        }

        // SUCCESS CASE
        if (data.task_code) {
            document.getElementById("response").innerText =
                `Task Created: ${data.task_code}`;

            document.getElementById("message").value = "";

            return loadTasks().then(() => {
                lookupTask();
            });
        }

        // FALLBACK ERROR CASE
        document.getElementById("response").innerText =
            `Error: ${data.error || "Unknown failure"}`;
    })
    .catch(err => {
        console.error("Network/JS error:", err);
        document.getElementById("response").innerText =
            "Network error (check console)";
    });
}

function loadTasks() {
    return fetch(`${BASE_URL}/tasks/`)
        .then(res => res.json())
        .then(data => {
            allTasks = data;
            let html = "";

            data.forEach(task => {
                const entities = escapeHtml(JSON.stringify(task.entities || {}, null, 2));
                const steps = (task.steps || [])
                    .map(step => `<li>${escapeHtml(step)}</li>`)
                    .join("");

                const history = (task.status_history || [])
                    .map(item => `<li>${escapeHtml(item.old_status || "Created")} -> ${escapeHtml(item.new_status)} (${new Date(item.changed_at).toLocaleString()})</li>`)
                    .join("");

                const whatsapp = escapeHtml(task.messages?.whatsapp || "");
                const email = escapeHtml(task.messages?.email || "");
                const sms = escapeHtml(task.messages?.sms || "");

                html += `
                    <div class="task">
                        <div class="task-top">
                            <div>
                                <p class="task-code">${escapeHtml(task.task_code)}</p>
                                <p class="task-intent">${escapeHtml((task.intent || "").replace(/_/g, " "))}</p>
                            </div>
                            <span class="badge status-badge ${statusClass(task.status)}">${escapeHtml(task.status)}</span>
                        </div>

                        <div class="badge-row">
                            <span class="badge badge-risk">Risk ${escapeHtml(task.risk_score)}</span>
                            <span class="badge badge-team">${escapeHtml(task.assigned_team)}</span>
                        </div>

                        <div class="meta-card">
                            <p class="meta-title">Created</p>
                            <p class="message-text">${new Date(task.created_at).toLocaleString()}</p>
                        </div>

                        <div class="meta-card">
                            <p class="meta-title">Entities</p>
                            <pre>${entities}</pre>
                        </div>

                        <div class="meta-card">
                            <p class="meta-title">Steps</p>
                            <ol class="steps-list">${steps}</ol>
                        </div>

                        <div class="message-block">
                            <p class="block-title">WhatsApp</p>
                            <p class="message-text">${whatsapp}</p>
                        </div>

                        <div class="message-block">
                            <p class="block-title">Email</p>
                            <p class="message-text">${email}</p>
                        </div>

                        <div class="message-block">
                            <p class="block-title">SMS</p>
                            <p class="message-text">${sms}</p>
                        </div>

                        <div class="history-block">
                            <p class="block-title">Status History</p>
                            <ul class="history-list">${history}</ul>
                        </div>

                        <div class="status-actions">
                            <button class="status-button" onclick="updateStatus('${task.task_code}', 'Pending')">Pending</button>
                            <button class="status-button" onclick="updateStatus('${task.task_code}', 'In Progress')">In Progress</button>
                            <button class="status-button" onclick="updateStatus('${task.task_code}', 'Completed')">Completed</button>
                        </div>
                    </div>
                `;
            });

            document.getElementById("tasks").innerHTML = html;
        })
        .catch(err => {
            console.error(err);
        });
}

function renderCustomerTask(task, taskCode, status) {
    const target = document.getElementById("customer-task");

    if (!task) {
        target.innerHTML = `
            <div class="customer-summary">
                <p class="message-text">No task found for that code.</p>
            </div>
        `;
        return;
    }

    const whatsapp = escapeHtml(task.messages?.whatsapp || "");
    const email = escapeHtml(task.messages?.email || "");
    const sms = escapeHtml(task.messages?.sms || "");

    target.innerHTML = `
        <div class="customer-summary">
            <p class="section-label">Customer Task Summary</p>

            <div class="task-top">
                <div>
                    <p class="task-code">Task Code: ${escapeHtml(taskCode)}</p>
                    <p class="task-intent">${escapeHtml(task.intent.replace(/_/g, " "))}</p>
                </div>
                <span class="badge status-badge ${statusClass(status)}">${escapeHtml(status)}</span>
            </div>

            <div class="summary-grid">
                <div class="meta-card">
                    <p class="meta-title">Task Code</p>
                    <p class="message-text">${escapeHtml(taskCode)}</p>
                </div>

                <div class="meta-card">
                    <p class="meta-title">Created</p>
                    <p class="message-text">${task.created_at ? new Date(task.created_at).toLocaleString() : "Just now"}</p>
                </div>

                <div class="meta-card">
                    <p class="meta-title">Status</p>
                    <p class="message-text">${escapeHtml(status)}</p>
                </div>

                <div class="meta-card">
                    <p class="meta-title">Assigned Team</p>
                    <p class="message-text">${escapeHtml(task.assigned_team || "Vunoh Team")}</p>
                </div>

                <div class="meta-card">
                    <p class="meta-title">Risk Score</p>
                    <p class="message-text">${escapeHtml(task.risk_score ?? "N/A")}</p>
                </div>
            </div>

            <div class="customer-messages">
                <div class="message-block">
                    <p class="block-title">WhatsApp Preview</p>
                    <p class="message-text">${whatsapp}</p>
                </div>

                <div class="message-block">
                    <p class="block-title">Email Preview</p>
                    <p class="message-text">${email}</p>
                </div>

                <div class="message-block">
                    <p class="block-title">SMS Preview</p>
                    <p class="message-text">${sms}</p>
                </div>
            </div>
        </div>
    `;
}

function lookupTask() {
    const code = document.getElementById("lookup-code").value.trim().toUpperCase();
    const task = allTasks.find(item => item.task_code === code);

    if (!code) {
        document.getElementById("customer-task").innerHTML = `
            <div class="customer-summary">
                <p class="message-text">Enter a task code to see the customer-facing status and confirmation messages.</p>
            </div>
        `;
        return;
    }

    if (!task) {
        renderCustomerTask(null);
        return;
    }

    renderCustomerTask(task, task.task_code, task.status);
}

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
            alert(`Updated: ${data.status}`);
        }

        loadTasks();
    })
    .catch(err => {
        console.error(err);
        alert("Update failed");
    });
}

loadTasks();
