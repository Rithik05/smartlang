import React, { useState } from "react";
import { Button } from "../../components/Button/Button";
import { Card } from "../../components/Card/Card";
import { UploadCloud, FileText, Loader2, Copy } from "lucide-react";
import Header from "../../components/Header/Header";

const Summarizer = () => {
  const [pdfFile, setPdfFile] = useState(null);
  const [summary, setSummary] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleFileChange = (e) => {
    setPdfFile(e.target.files[0]);
    setSummary("");
  };

  async function handleUpload() {
    if (!pdfFile) {
      alert("Please select a PDF file.");
      return;
    }

    const formData = new FormData();
    formData.append("file", pdfFile);
    let csrfToken =
      document.querySelector("meta[name='csrf-token']")?.getAttribute("content") ||
      "";

    try {
      setLoading(true);
      const response = await fetch("/summarizer/summarize", {
        method: "POST",
        body: formData,
        headers: { "x-csrf-token": csrfToken }
      });

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const data = await response.json();
      setSummary(data.response);
      setLoading(false)
    } catch (error) {
      console.error("Error summarising PDF:", error);
      setSummary([{text: "Failed to summarise the PDF."}]);
    }
  };

  return (
    <div>
      <Header />
      <div className="flex flex-col items-center justify-center min-h-screen bg-gray-200 p-6">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold text-gray-900 mb-4">Summarizer</h1>
          <p className="text-gray-600 text-lg max-w-2xl mx-auto">
            Instantly get a concise summary of your PDFs
          </p>
        </div>
        <Card className="w-full max-w-xl p-6 shadow-lg rounded-2xl border border-gray-200">
          <h1 className="text-3xl font-bold mb-4 text-center flex items-center gap-2">
            <FileText className="w-8 h-8 text-blue-500" /> PDF Summariser
          </h1>

          <input
            type="file"
            accept="application/pdf"
            onChange={handleFileChange}
            className="block w-full text-sm text-gray-700 mb-4 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-600 hover:file:bg-blue-100"
          />

          <Button
            onClick={handleUpload}
            disabled={!pdfFile || loading}
            className="w-full flex items-center justify-center gap-2"
          >
            {loading ? (
              <>
                <Loader2 className="animate-spin w-5 h-5" /> Processing...
              </>
            ) : (
              <>
                <UploadCloud className="w-5 h-5" /> Upload & Summarise
              </>
            )}
          </Button>

          {summary && (
            <div className="mt-6 bg-white rounded-xl p-4 border border-gray-200">
              <div className="flex items-start justify-between">
                <p className="text-gray-900 whitespace-pre-line flex-1">
                  {summary.map((s) => s.text).join("\n")}
                </p>
                <button
                  onClick={() =>
                    navigator.clipboard.writeText(summary.map((s) => s.text).join("\n"))
                  }
                  className="ml-4 p-2 rounded text-black hover:bg-gray-100"
                  title="Copy to clipboard"
                >
                  <Copy size={22} />
                </button>
              </div>
            </div>
          )}

        </Card>
      </div>
    </div>
  );
};

export default Summarizer;