import { Routes, Route } from "react-router-dom";
import PostList from "./pages/PostList";
import PostDetail from "./pages/PostDetail";
import PostForm from "./pages/PostForm";

function App() {
  return (
      <Routes>
        <Route path="/" element={<PostList />} />
        <Route path="/post/:id" element={<PostDetail />} />
        <Route path="/post/new" element={<PostForm />} />
        <Route path="/post/edit/:id" element={<PostForm />} />
      </Routes>
  );
}

export default App;
