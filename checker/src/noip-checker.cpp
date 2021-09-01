#include <iostream>
#include "file.h"

// Compare two files using NOIP rules.
// i.e. ignore spaces before \n or \n before EOF
//
// Return value:
// return true if the output passes the case;
// otherwise the function will output the error to stdout and returns false
bool compare(std::ifstream &&outputStream, std::ifstream &&answerStream) {
    File output(std::move(outputStream)), answer(std::move(answerStream));
    for (;;) {
        // Handle EOF
        if (!output.next()) {
            DEBUG_OUTPUT("!output.next()");
            
            if(answer.willEOF()) return true;
            
            if (answer.charactersInRemainingLine(false) && output.getLine()==answer.getLine()){
                std::cerr << "wrong answer Too short on line " << answer.getLine() << ".";
                return false;
            } else if (answer.charactersInRemainingFile(true)){
                std::cerr << "wrong answer Too few lines.";  // actually too few
                return false;
            } else return true;
        }
        
        if (!answer.next()) {
            DEBUG_OUTPUT("!answer.next()");
            if (output.charactersInRemainingLine(true) && output.getLine()==answer.getLine()){
                std::cerr << "wrong answer Too long on line " << answer.getLine() << ".";
                return false;
            } else if (output.charactersInRemainingFile(true)){
                std::cerr << "wrong answer Too many lines.";  // actually too many
                return false;
            } else return true;
        }

        output._dbg();answer._dbg();
        // Compare
        if (output.get() != answer.get()) {
            DEBUG_OUTPUT("output.get() != answer.get()");
            auto line = answer.getLine();
            auto column = answer.getColumn();
            auto charRead = output.get();
            auto expected = answer.get();
            bool outputHasMore = output.charactersInRemainingLine(true);
            bool answerHasMore = answer.charactersInRemainingLine(true);
            DEBUG_OUTPUT("outputHasMore=" << outputHasMore << ",answerHasMore=" << answerHasMore);
            if (outputHasMore || answerHasMore) {
                if (outputHasMore && answerHasMore) {
                    std::cerr << "wrong answer On line " << line << " column " << column << ", read ";
                    if (charRead <= 32 || charRead >= 127)
                        std::cerr << "(ASCII " << static_cast<int>(charRead) << ")";
                    else
                        std::cerr << charRead;
                    std::cerr << ", expected " << expected << ".";
                } else
                    std::cerr << "wrong answer Too " << (answerHasMore ? "short" : "long") << " on line " << line << ".";
                return false;
            }
        }
    }
    return true;
}

int main(int argc, char *argv[]) {
    if (argc < 4) {
        std::cerr << "FAIL Program must be run with the following arguments: <input-file> <output-file> <answer-file>" << std::endl;
        return -1;
    }

    // the input file (argv[1]) is ignored since it's not needed.
    auto outputFile = std::ifstream(argv[2], std::ifstream::binary);
    if (outputFile.fail()) {
        std::cerr << "FAIL Output file not found: \"" << argv[2] << "\"" << std::endl;
        return -1;
    }
    auto answerFile = std::ifstream(argv[3], std::ifstream::binary);
    if (answerFile.fail()) {
        std::cerr << "FAIL Answer file not found: \"" << argv[3] << "\"" << std::endl;
        return -1;
    }
    if (compare(std::move(outputFile), std::move(answerFile)))
        std::cerr << "ok accepted";
    // otherwise the error is already outputed in compare
}
