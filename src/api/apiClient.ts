import axios from "axios";

const apiClient = axios.create({
    baseURL: 'http://34.64.75.108:8081',
    headers: {
        "Content-Type": "application/json",
    },
});

export default apiClient;
