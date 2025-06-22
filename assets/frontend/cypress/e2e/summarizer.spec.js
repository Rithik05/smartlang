describe("Summarizer Page Test", () => {
    beforeEach(() => {
        cy.mockLoginAuthorizedUser()
        cy.visit("/summarizer") // only an authorized user would be able to navigate to Summarizer page
    })
    it("should render summarizer page elements", () => {
        cy.contains('Summarizer')
        cy.get('input[type=file]').should('exist')
        cy.get('button').contains('Upload & Summarise').should('exist').should('be.disabled')
    })

    it("should support file upload", () => {
        cy.get('input[type=file]').selectFile('cypress/fixtures/test.pdf')
        cy.contains('Upload & Summarise').should('not.be.disabled')
    })

    it("should show summary after file upload (mock response)", () => {
        cy.mockSummarizeApi()
        cy.get('input[type="file"]').selectFile('cypress/fixtures/test.pdf')
        cy.contains('Upload & Summarise').click()

        cy.wait('@summariseRequest')

        cy.contains('This is a mock summary.').should('exist')
        cy.get('button[title="Copy to clipboard"]').click()

        // Verify Copied Content
        cy.window().then((win) => {
            return win.navigator.clipboard.readText().then((text) => {
                expect(text).to.eq('This is a mock summary.')
            })
        })
    })
})