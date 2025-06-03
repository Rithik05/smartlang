import { useNavigate } from "react-router-dom";
import Header from "../../components/Header/Header";

function Home() {
    const navigate = useNavigate();

    return (
        <div>
            <Header />
            <div className="min-h-screen flex items-center justify-center bg-gray-600">
                <div className="border border-gray-700 bg-gray-800 p-10 rounded-2xl max-w-2xl mx-auto shadow-xl">
                    <h2 className="text-4xl font-bold text-white text-center mb-8">Smartlang-AI</h2>
                    <p className="text-center text-gray-400 mb-10">
                        Your AI-powered toolkit for text summarization and language translation.
                    </p>

                    <div className="flex justify-center gap-10">
                        <div className="flex flex-col items-center">
                            <button
                                className="bg-blue-500 text-white px-6 py-3 rounded-lg hover:bg-blue-800 transition"
                                onClick={() => navigate("/summarizer")}
                            >
                                Summarizer
                            </button>
                            <span className="mt-3 text-sm text-gray-400 text-center max-w-[200px]">
                                Quickly get a concise summary of your PDFs
                            </span>
                        </div>

                        <div className="flex flex-col items-center">
                            <button
                                className="bg-blue-500 text-white px-6 py-3 rounded-lg hover:bg-blue-800 transition"
                                onClick={() => navigate("/translator")}
                            >
                                Translator
                            </button>
                            <span className="mt-3 text-sm text-gray-400 text-center max-w-[200px]">
                                Instantly translate text from one language to another.
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Home;