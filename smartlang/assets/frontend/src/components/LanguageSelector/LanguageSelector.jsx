import { useState } from "react";
import { ChevronDown, Search } from "lucide-react";
import { useFetch } from "../../hooks/useFetch";
import { useEffect } from "react";

export default function LanguageSelector({ onSelect }) {
    const [open, setOpen] = useState(false);
    const [query, setQuery] = useState("");
    const [displayName, setDisplayName] = useState("");
    const { response, makeRequest } = useFetch();

    const supported_languages = response?.response?.languages || [];
    const filteredLanguages = supported_languages.filter(lang =>
        lang.displayName.toLowerCase().includes(query.toLowerCase())
    );

    useEffect(() => {
        makeRequest({
            method: "GET",
            url: "http://localhost:4000/translator/supported_languages"
        });
    }, [makeRequest]);

    return (
        <div className="relative inline-block text-left">
            {/* Button */}
            <button
                onClick={() => setOpen(!open)}
                className="flex items-center gap-2 bg-gray-800 text-white px-4 py-2 rounded-lg"
            >
                {displayName ? displayName : "Choose Language"}
                <ChevronDown size={18} />
            </button>

            {/* Dropdown Menu */}
            {open && (
                <div className="absolute z-50 mt-2 w-64 bg-gray-800 rounded-lg shadow-lg p-4">
                    {/* Search Input */}
                    <div className="flex items-center gap-2 mb-3 bg-gray-700 px-3 py-2 rounded">
                        <Search size={16} className="text-gray-400" />
                        <input
                            type="text"
                            placeholder="Search languages..."
                            value={query}
                            onChange={(e) => setQuery(e.target.value)}
                            className="bg-transparent outline-none text-white w-full placeholder-gray-400 text-sm"
                        />
                    </div>

                    {/* Language List */}
                    <div className="max-h-60 overflow-y-auto space-y-1">
                        {filteredLanguages.map(lang => (
                            <button
                                key={lang.languageCode}
                                onClick={() => {
                                    onSelect(lang.languageCode);
                                    setDisplayName(lang.displayName)
                                    setOpen(false);
                                    setQuery("");
                                }}
                                className="w-full text-left px-3 py-2 rounded hover:bg-gray-700 text-white"
                            >
                                {lang.displayName}
                            </button>
                        ))}
                        {/* {filteredLanguages.map((lang) => (
              <button
                key={lang}
                onClick={() => {
                  onSelect(lang);
                  setOpen(false);
                  setQuery("");
                }}
                className="w-full text-left px-3 py-2 rounded hover:bg-gray-700 text-white"
              >
                {lang}
              </button>
            ))} */}
                        {filteredLanguages.length === 0 && (
                            <div className="text-gray-400 text-sm px-3 py-2">No results found</div>
                        )}
                    </div>
                </div>
            )}
        </div>
    );
}
