import axios from "axios";

const apiClient = axios.create({
    baseURL: "http://localhost:8080/api/posts", // 백엔드 API 주소
    headers: {
        "Content-Type": "application/json",
    },
});

export default apiClient;
