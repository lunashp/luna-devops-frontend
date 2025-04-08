import {describe, it, expect, vi, beforeEach} from "vitest";
import apiClient from "../../api/apiClient.ts";
import {createPost, deletePost, getPostById, getPosts, updatePost} from "../../api/postApi.ts";

vi.mock("../../api/apiClient", () => ({
    default: {
        get: vi.fn(),
        post: vi.fn(),
        put: vi.fn(),
        delete: vi.fn(),
    },
}));

describe("게시판CRUD", () => {
    beforeEach(() => {
        vi.clearAllMocks();
    });

    it("전체 목록 조회", async () => {
        const mockData = [{id: 1, title: "Hello", content: "World"}, {id: 2, title: "Bye", content: "World"}];
        (apiClient.get as ReturnType<typeof vi.fn>).mockResolvedValue({data: mockData});

        const result = await getPosts();

        expect(apiClient.get).toHaveBeenCalledWith("/");
        expect(result).toEqual(mockData);
        console.log("result", result)
        console.log("mockData", mockData)
    });

    it("상세 조회", async () => {
        const mockData = {id: 1, title: "Post", content: "Content"};
        (apiClient.get as ReturnType<typeof vi.fn>).mockResolvedValue({data: mockData});

        const result = await getPostById(1);

        expect(apiClient.get).toHaveBeenCalledWith("/1");
        expect(result).toEqual(mockData);
    });

    it("게시물 생성", async () => {
        const newPost = {title: "New", content: "Post"};
        const mockResponse = {id: 2, ...newPost};
        (apiClient.post as ReturnType<typeof vi.fn>).mockResolvedValue({data: mockResponse});

        const result = await createPost(newPost);

        expect(apiClient.post).toHaveBeenCalledWith("/", newPost);
        expect(result).toEqual(mockResponse);
    });

    it("게시물 수정", async () => {
        const updatedPost = {title: "Updated", content: "Content"};
        const mockResponse = {id: 1, ...updatedPost};
        (apiClient.put as ReturnType<typeof vi.fn>).mockResolvedValue({data: mockResponse});

        const result = await updatePost(1, updatedPost);

        expect(apiClient.put).toHaveBeenCalledWith("/1", updatedPost);
        expect(result).toEqual(mockResponse);
    });

    it("게시물 삭제", async () => {
        (apiClient.delete as ReturnType<typeof vi.fn>).mockResolvedValue(undefined);

        await deletePost(1);

        expect(apiClient.delete).toHaveBeenCalledWith("/1");
    });
});