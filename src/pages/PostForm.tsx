import { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { createPost, updatePost, getPostById } from "../api/postApi";

const PostForm = () => {
    const { id } = useParams<{ id: string }>();
    const navigate = useNavigate();
    const [title, setTitle] = useState("");
    const [content, setContent] = useState("");

    useEffect(() => {
        if (id) {
            getPostById(Number(id)).then((post) => {
                setTitle(post.title);
                setContent(post.content);
            });
        }
    }, [id]);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (id) {
            await updatePost(Number(id), { title, content });
        } else {
            await createPost({ title, content });
        }
        navigate("/");
    };

    return (
        <form onSubmit={handleSubmit}>
            <h1>{id ? "게시글 수정" : "새 게시글 작성"}</h1>
            <input value={title} onChange={(e) => setTitle(e.target.value)} placeholder="제목" />
            <textarea value={content} onChange={(e) => setContent(e.target.value)} placeholder="내용"></textarea>
            <button type="submit">저장</button>
        </form>
    );
};

export default PostForm;
