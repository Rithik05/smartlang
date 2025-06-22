import { useState } from "react";
import LanguageSelector from "../../components/LanguageSelector/LanguageSelector";
import { useFetch } from "../../hooks/useFetch";
import { useEffect } from "react";
import { Loader2, Copy } from "lucide-react";
import Header from "../../components/Header/Header";

function Translator() {
    const [selectedSourceLanguage, setSourceLanguage] = useState("");
    const [selectedTargetLanguage, setTargetLanguage] = useState("");
    const [inputText, setInputText] = useState("");
    const [translatedText, setTranslatedText] = useState("");
    const { loading, makeRequest } = useFetch();

    useEffect(() => {
        if (!inputText) {
            setTranslatedText("");
            return;
        }
        const fetchTranslation = async () => {
            const result = await makeRequest({
                method: "POST",
                url: "/translator/translate",
                params: {
                    source: selectedSourceLanguage,
                    target: selectedTargetLanguage,
                    text: inputText
                }
            });

            if (result.data && result.data.response && result.data.response.translations && result.data.response.translations.length > 0) {
                setTranslatedText(result.data.response.translations[0].translatedText);
            }
        };
        fetchTranslation();
    }, [inputText, selectedSourceLanguage, selectedTargetLanguage, makeRequest]);

    return (
        <div>
            <Header />
            <div id="translator" className="min-h-screen bg-gradient-to-b from-gray-50 flex flex-col items-center justify-center py-12">
                <div className="text-center mb-12">
                    <h1 className="text-5xl font-bold text-gray-900 mb-4">Translator</h1>
                    <p className="text-gray-600 text-lg max-w-2xl mx-auto">
                        Instantly translate text between different languages. Type or paste your text and get fast, accurate translations in your chosen language.
                    </p>
                </div>

                <div className="bg-gray-900 text-black p-10 rounded-2xl shadow-2xl">
                    <div className="flex gap-8 max-w-7xl mx-auto">
                        <div id="sourceLanguage" className="w-[650px] bg-gray-700 rounded-xl p-6 flex flex-col gap-6">
                            <LanguageSelector
                                selected={selectedSourceLanguage}
                                onSelect={(lang) => setSourceLanguage(lang)}
                            />
                            <textarea
                                className="bg-gray-900 text-white p-5 rounded-lg h-[350px] resize-none outline-none text-lg"
                                value={inputText}
                                onChange={(e) => setInputText(e.target.value)}
                                placeholder="Start Typing..."
                            ></textarea>
                        </div>

                        <div id="targetLanguage" className="w-[650px] bg-gray-700 rounded-xl p-6 flex flex-col gap-6 relative">
                            <LanguageSelector
                                onSelect={(langCode) => setTargetLanguage(langCode)}
                            />

                            <button
                                onClick={() => navigator.clipboard.writeText(translatedText)}
                                className="absolute top-6 right-6 text-white hover:text-gray-400"
                            >
                                <Copy size={22} />
                            </button>

                            <div className="bg-gray-900 text-white p-5 rounded-lg h-[350px] text-lg overflow-y-auto">
                                {loading ? (
                                    <Loader2 className="animate-spin text-gray-400" size={24} />
                                ) : (
                                    translatedText || "Translation will appear here..."
                                )}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default Translator;